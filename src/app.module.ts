import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { BusinessModule } from './business/business.module';
import { Business } from './entities/business.entity';
import { AuthModule } from './auth/auth.module';
import { QRCodeModule } from './qr-code/qr-code.module';
import { User } from './entities/user.entity';
import { BusinessCategory } from './entities/business-category.entity';
import { BusinessLink } from './entities/business-link.entity';
import { QRCode } from './entities/qr-code.entity';
import { QRCodeScan } from './entities/qr-code-scan.entity';

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
      entities: [
        Business,
        User,
        BusinessCategory,
        BusinessLink,
        QRCode,
        QRCodeScan,
      ],
      synchronize: process.env.NODE_ENV !== 'production', // Don't use in production!
    }),
    BusinessModule,
    AuthModule,
    QRCodeModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
