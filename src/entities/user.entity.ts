import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { Business } from './business.entity';
import { QRCode } from './qr-code.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column()
  passwordHash: string;

  @Column()
  firstName: string;

  @Column()
  lastName: string;

  @Column({ nullable: true })
  phone?: string;

  @Column({ default: false })
  isAdmin: boolean;

  @Column({ nullable: true })
  profileImage?: string;

  @OneToMany(() => Business, business => business.owner)
  businesses: Business[];

  @OneToMany(() => QRCode, qrCode => qrCode.owner)
  qrCodes: QRCode[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
} 