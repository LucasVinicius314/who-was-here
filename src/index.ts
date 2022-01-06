import * as SerialPort from 'serialport'
import * as Server from 'http'
import * as dotenv from 'dotenv'

import { models, sequelize } from './services/sequelize'

import { Log } from './typescript/log'
import { Model } from 'sequelize/dist'
import { Server as SocketIO } from 'socket.io'
import audioLoader from 'audio-loader'
import audioPlay from 'audio-play'
import { ipLookup } from './utils/iplookup'

dotenv.config()

const comPath = process.env.COMPATH
const baudRate = process.env.BAUDRATE
const port = process.env.PORT

const setup = async () => {
  await sequelize
    .authenticate()
    .then(() => console.log('Database auth ok'))
    .catch(console.log)

  await sequelize
    .sync({ alter: true, force: false, logging: false })
    .then(() => console.log('Database sync ok'))
    .catch(console.log)

  const app = Server.createServer()

  const io = new SocketIO(app, {
    transports: ['websocket'],
    allowEIO3: true,
  })

  const serialPort = new SerialPort.default(comPath, {
    baudRate: parseInt(baudRate),
  })

  serialPort.addListener('data', async (chunk: Buffer) => {
    console.log(chunk.toString('utf-8'))

    await audioLoader('./enemy-detected.mp3').then(audioPlay)

    const log = await models.Log.create<Model<Log>>({ tag: 'pir sensor' })

    io.emit('new', log)
  })

  console.info(`Listening to ${comPath}, baud rate ${baudRate}`)

  io.on('connection', (socket) => {
    console.log('client connected')

    socket.on('all', async (data) => {
      const logs = await models.Log.findAll({
        order: [['createdAt', 'desc']],
      })

      socket.emit('all', logs)
    })
  })

  io.engine.on('connection_error', console.error)

  app.listen(port, async () => {
    console.info(`Listening on port ${port}`)
    console.info(`Address: ${await ipLookup()}:${port}/`)
  })
}

setup()
