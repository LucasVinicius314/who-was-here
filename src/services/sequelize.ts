import * as dotenv from 'dotenv'

import { DataTypes, Sequelize } from 'sequelize'

dotenv.config()

export const sequelize = new Sequelize(process.env.DATABASE_URL, {
  ssl: false,
  dialect: 'postgres',
})

const Log = sequelize.define('log', {
  tag: DataTypes.STRING,
})

export const models = { Log }
