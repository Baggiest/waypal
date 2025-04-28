import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, ManyToOne, OneToMany, JoinColumn } from 'typeorm';
import { User } from './user.entity';
import { Business } from './business.entity';
import { QRCodeScan } from './qr-code-scan.entity';

@Entity('qr_codes')
export class QRCode {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  code: string;

  @Column({ nullable: true })
  description?: string;

  @Column({ nullable: true })
  imageUrl?: string;

  @Column({ default: true })
  isActive: boolean;

  @Column({ type: 'jsonb', nullable: true })
  metadata?: Record<string, any>;

  @ManyToOne(() => User, user => user.qrCodes)
  @JoinColumn()
  owner: User;

  @ManyToOne(() => Business, business => business.qrCodes)
  @JoinColumn()
  business: Business;

  @OneToMany(() => QRCodeScan, scan => scan.qrCode)
  scans: QRCodeScan[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
} 