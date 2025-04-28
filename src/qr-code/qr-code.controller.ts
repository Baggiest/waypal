import { Controller, Get, Post, Body, Param, UseGuards, Request } from '@nestjs/common';
import { QRCodeService } from './qr-code.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Business } from '../entities/business.entity';
import { User } from '../entities/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Controller('qr-codes')
export class QRCodeController {
  constructor(
    private readonly qrCodeService: QRCodeService,
    @InjectRepository(Business)
    private businessRepository: Repository<Business>,
  ) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  async createQRCode(
    @Request() req,
    @Body() data: {
      name: string;
      description?: string;
      businessId: string;
      metadata?: Record<string, any>;
    },
  ) {
    const user = req.user as User;
    const business = await this.businessRepository.findOne({
      where: { id: data.businessId }
    });

    if (!business) {
      throw new Error('Business not found');
    }

    return this.qrCodeService.createQRCode({
      ...data,
      business,
      owner: user,
    });
  }

  @Post('scan/:code')
  async scanQRCode(
    @Param('code') code: string,
    @Body() scanData: {
      deviceInfo?: string;
      location?: string;
      referrer?: string;
      metadata?: Record<string, any>;
    },
  ) {
    return this.qrCodeService.scanQRCode(code, scanData);
  }

  @Get(':id/stats')
  @UseGuards(JwtAuthGuard)
  async getQRCodeStats(@Param('id') id: string) {
    return this.qrCodeService.getQRCodeStats(id);
  }

  @Post(':id/deactivate')
  @UseGuards(JwtAuthGuard)
  async deactivateQRCode(@Param('id') id: string) {
    return this.qrCodeService.deactivateQRCode(id);
  }
} 