import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as backendIdlFactory } from '../../../../declarations/icp_hello_world_motoko_backend/icp_hello_world_motoko_backend.did.js';
import { canisterId as backendCanisterId } from '../../../../declarations/icp_hello_world_motoko_backend';

@Component({
  selector: 'app-upload',
  standalone: true,
  imports: [],
  templateUrl: './upload.component.html',
  styleUrl: './upload.component.scss'
})
export class UploadComponent {
  private backendActor;

  constructor(private http: HttpClient) {
    const agent = new HttpAgent();
    this.backendActor = Actor.createActor(backendIdlFactory, {
      agent,
      canisterId: backendCanisterId,
    });
  }

  async uploadImage(event: any) {
    const file: File = event.target.files[0];
    if (file) {
      const arrayBuffer = await file.arrayBuffer();
      const blob = new Uint8Array(arrayBuffer);
      const imageId = await this.backendActor.uploadImage(blob);
      console.log('Image uploaded with ID:', imageId);
    }
  }

  async getImage(id: number) {
    const imageBlob = await this.backendActor.getImage(BigInt(id));
    if (imageBlob) {
      const blob = new Blob([new Uint8Array(imageBlob)], { type: 'image/png' });
      const url = URL.createObjectURL(blob);
      window.open(url);
    }
  }
}
