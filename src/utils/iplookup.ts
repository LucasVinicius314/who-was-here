import { hostname } from 'os'
import { lookup } from 'dns'

export const ipLookup = () =>
  new Promise((resolve, reject) => {
    lookup(hostname(), (err, add, fam) => {
      if (err) reject(err)

      resolve(add)
    })
  })
