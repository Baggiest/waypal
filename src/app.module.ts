import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { BusinessModule } from './business/business.module';
import { Business } from './business/entities/business.entity';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT!),
      username: process.env.DB_USERNAME,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      entities: [Business],
      synchronize: process.env.NODE_ENV !== 'production', // Don't use in production!
    }),
    BusinessModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
