import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { QRCodeController } from './qr-code.controller';
import { QRCodeService } from './qr-code.service';
import { QRCode } from '../entities/qr-code.entity';
import { QRCodeScan } from '../entities/qr-code-scan.entity';
import { Business } from '../entities/business.entity';

@Module({
  imports: [TypeOrmModule.forFeature([QRCode, QRCodeScan, Business])],
  controllers: [QRCodeController],
  providers: [QRCodeService],
  exports: [QRCodeService],
})
export class QRCodeModule {} 