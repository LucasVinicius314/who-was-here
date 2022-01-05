import * as SerialPort from 'serialport'
import * as dotenv from 'dotenv'

import { models, sequelize } from './services/sequelize'

import { Log } from './typescript/log'
import { Model } from 'sequelize/dist'
import audioLoader from 'audio-loader'
import audioPlay from 'audio-play'

dotenv.config()

const comPath = process.env.COMPATH
const baudRate = process.env.BAUDRATE

const setup = async () => {
  await sequelize
    .authenticate()
    .then(() => console.log('Database auth ok'))
    .catch(console.log)

  await sequelize
    .sync({ alter: true, force: false, logging: false })
    .then(() => console.log('Database sync ok'))
    .catch(console.log)

  const port = new SerialPort.default(comPath, { baudRate: parseInt(baudRate) })

  port.addListener('data', async (chunk: Buffer) => {
    console.log(chunk.toString('utf-8'))

    await audioLoader('./enemy-detected.mp3').then(audioPlay)

    await models.Log.create<Model<Log>>({ tag: 'pir sensor' })
  })

  console.log(`Listening to ${comPath}, baud rate ${baudRate}`)
}

setup()
