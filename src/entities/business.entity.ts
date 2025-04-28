import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, ManyToOne, OneToMany, JoinColumn } from 'typeorm';
import { Point } from 'geojson';
import { User } from './user.entity';
import { QRCode } from './qr-code.entity';
import { BusinessLink } from './business-link.entity';
import { BusinessCategory } from './business-category.entity';

@Entity('businesses')
export class Business {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  description: string;

  @Column()
  address: string;

  @Column('geometry', {
    spatialFeatureType: 'Point',
    srid: 4326,
  })
  location: Point;

  @Column({ nullable: true })
  website?: string;

  @Column({ nullable: true })
  phone?: string;

  @Column('decimal', { nullable: true, precision: 3, scale: 2 })
  rating?: number;

  @Column({ nullable: true })
  logo?: string;

  @Column({ nullable: true })
  coverImage?: string;

  @Column({ nullable: true })
  businessHours?: string;

  @Column({ default: true })
  isActive: boolean;

  @Column({ nullable: true })
  socialMedia?: string;

  @Column({ nullable: true })
  menuUrl?: string;

  @Column({ nullable: true })
  reservationUrl?: string;

  @ManyToOne(() => User, user => user.businesses)
  @JoinColumn()
  owner: User;

  @ManyToOne(() => BusinessCategory)
  @JoinColumn()
  category: BusinessCategory;

  @OneToMany(() => QRCode, qrCode => qrCode.business)
  qrCodes: QRCode[];

  @OneToMany(() => BusinessLink, link => link.business)
  links: BusinessLink[];

  @Column({ type: 'jsonb', nullable: true })
  metadata?: Record<string, any>;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  // Virtual field for distance calculations
  distance?: number;
} 