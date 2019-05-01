class Particle {
  constructor(args) {
    this.position = args.position;
    this.speed = args.speed;
    this.speedMagnet = args.speedMagnet;
    this.offset = args.offset;
    this.imgData = null;
    this.size = null;
  }

  draw(p) {
    const toUnsigned = val => {
      return p.map(val, -1, 1, 0, 1);
    };
    // Don't draw, if image is not loaded yet.
    if (!this.imgData) return;

    let fac = toUnsigned(
      p.sin(((p.TWO_PI * p.frameCount) / 200) * this.speedMagnet)
    );

    let x_ = this.position.x * p.width;
    let x = p.mouseX + fac * (x_ - p.mouseX);

    let y_ = this.position.y * p.height;
    let y = p.mouseY + fac * (y_ - p.mouseY);

    const w =
      config.maxImgSize *
      p.width *
      p.sin(p.HALF_PI * this.offset + (p.HALF_PI * p.frameCount) / 100);
    const h = w;

    p.push();

    p.translate(x, y);
    p.rotate(p.TWO_PI * ((p.frameCount / 50) * this.speed));
    p.translate(-x, -y);
    p.image(this.imgData, x, y, w, h);
    p.pop();
  }
}
