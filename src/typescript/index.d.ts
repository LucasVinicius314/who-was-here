declare global {
  namespace NodeJS {
    interface ProcessEnv {
      NODE_ENV: 'development' | 'production'
      DATABASE_URL: string
      COMPATH: string
      BAUDRATE: string
      PORT: string
    }
  }
}

export {}
