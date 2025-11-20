import {Sequelize} from 'sequelize-typescript';
import {config} from './config/config';


// Only use SSL for AWS RDS (not for local postgres)
const useSSL = config.host && !config.host.includes('localhost') && !config.host.includes('postgres');

export const sequelize = new Sequelize({
  'username': config.username,
  'password': config.password,
  'database': config.database,
  'host': config.host,

  'dialect': 'postgres',
  dialectOptions: useSSL ? {
    ssl: {
      require: true,
      rejectUnauthorized: false 
    }
  } : {},
  'storage': ':memory:',
});
