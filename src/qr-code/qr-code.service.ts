import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { QRCode } from '../entities/qr-code.entity';
import { QRCodeScan } from '../entities/qr-code-scan.entity';
import { Business } from '../entities/business.entity';
import { User } from '../entities/user.entity';
import * as QRCodeLib from 'qrcode';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class QRCodeService {
  constructor(
    @InjectRepository(QRCode)
    private qrCodeRepository: Repository<QRCode>,
    @InjectRepository(QRCodeScan)
    private qrCodeScanRepository: Repository<QRCodeScan>,
  ) {}

  async createQRCode(data: {
    name: string;
    description?: string;
    business: Business;
    owner: User;
    metadata?: Record<string, any>;
  }): Promise<QRCode> {
    const code = uuidv4();
    const qrCode = this.qrCodeRepository.create({
      ...data,
      code,
    });

    // Generate QR code image
    const qrCodeImage = await QRCodeLib.toDataURL(code);
    qrCode.imageUrl = qrCodeImage;

    return this.qrCodeRepository.save(qrCode);
  }

  async scanQRCode(code: string, scanData: {
    deviceInfo?: string;
    location?: string;
    referrer?: string;
    metadata?: Record<string, any>;
  }): Promise<QRCode> {
    const qrCode = await this.qrCodeRepository.findOne({
      where: { code },
      relations: ['business'],
    });

    if (!qrCode) {
      throw new Error('QR code not found');
    }

    if (!qrCode.isActive) {
      throw new Error('QR code is inactive');
    }

    // Record the scan
    const scan = this.qrCodeScanRepository.create({
      qrCode,
      ...scanData,
    });

    await this.qrCodeScanRepository.save(scan);

    return qrCode;
  }

  async getQRCodeStats(qrCodeId: string): Promise<{
    totalScans: number;
    scansByDay: { date: string; count: number }[];
    scansByLocation: { location: string; count: number }[];
  }> {
    const totalScans = await this.qrCodeScanRepository.count({
      where: { qrCode: { id: qrCodeId } },
    });

    const scansByDay = await this.qrCodeScanRepository
      .createQueryBuilder('scan')
      .select('DATE(scan.scannedAt)', 'date')
      .addSelect('COUNT(*)', 'count')
      .where('scan.qrCodeId = :qrCodeId', { qrCodeId })
      .groupBy('DATE(scan.scannedAt)')
      .orderBy('DATE(scan.scannedAt)', 'DESC')
      .getRawMany();

    const scansByLocation = await this.qrCodeScanRepository
      .createQueryBuilder('scan')
      .select('scan.location', 'location')
      .addSelect('COUNT(*)', 'count')
      .where('scan.qrCodeId = :qrCodeId', { qrCodeId })
      .groupBy('scan.location')
      .orderBy('COUNT(*)', 'DESC')
      .getRawMany();

    return {
      totalScans,
      scansByDay,
      scansByLocation,
    };
  }

  async deactivateQRCode(id: string): Promise<QRCode> {
    const qrCode = await this.qrCodeRepository.findOne({
      where: { id },
    });

    if (!qrCode) {
      throw new Error('QR code not found');
    }

    qrCode.isActive = false;
    return this.qrCodeRepository.save(qrCode);
  }
} 