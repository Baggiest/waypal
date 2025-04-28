import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { QRCode } from './qr-code.entity';

@Entity('qr_code_scans')
export class QRCodeScan {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => QRCode, qrCode => qrCode.scans)
  @JoinColumn()
  qrCode: QRCode;

  @Column({ nullable: true })
  deviceInfo?: string;

  @Column({ nullable: true })
  location?: string;

  @Column({ nullable: true })
  referrer?: string;

  @Column({ type: 'jsonb', nullable: true })
  metadata?: Record<string, any>;

  @CreateDateColumn()
  scannedAt: Date;
} 