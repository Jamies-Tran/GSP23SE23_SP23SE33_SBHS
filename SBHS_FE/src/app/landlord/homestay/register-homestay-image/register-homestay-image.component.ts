import { Component } from '@angular/core';

@Component({
  selector: 'app-register-homestay-image',
  templateUrl: './register-homestay-image.component.html',
  styleUrls: ['./register-homestay-image.component.scss']
})
export class RegisterHomestayImageComponent {

  files: File[] = [];
  file!: File;

  onSelect(files: any) {
    console.log(event);
    this.files.push(...files.addedFiles);

  }

  onRemove(event: File) {
    console.log(event);
    this.files.splice(this.files.indexOf(event), 1);
    console.log('files lenght: ', this.files.length);

  }
}
