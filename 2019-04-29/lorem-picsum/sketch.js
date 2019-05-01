const config = {
  countImgs: 20,
  frameRate: 24
};

new p5(function(p) {
  let imgs = [];

  for (let i = 0; i < config.countImgs; i++) {
    imgs[i] = {
      position: { x: p.random(), y: p.random() },
      speed: p.random([p.random(-1, -0.5), p.random(0.5, 1)]),
      speedMagnet: p.random(0.5, 1),
      offset: p.random()
    };
  }

  p.preload = () => {
    const url = `https://picsum.photos/v2/list?page=2&limit=${
      config.countImgs
    }`;
    p.httpGet(url, result => {
      const items = p.shuffle(JSON.parse(result));

      items.forEach((item, i) => {
        const width = p.round(p.width / 20);
        const height = width;
        const imgUrl = `https://picsum.photos/id/${item.id}/${width}/${height}`;
        imgs[i].imgData = p.loadImage(imgUrl);
        imgs[i].size = { width, height };
      });
    });
  };

  p.setup = () => {
    p.frameRate(config.frameRate);
    p.createCanvas(p.windowWidth, p.windowHeight);
    console.log(p.frameRate);
  };

  p.draw = () => {
    p.background(200);
    imgs.forEach(img => {
      if (!img.imgData) return;

      p.imageMode(p.CENTER);

      let fac = toUnsigned(
        p.sin(((p.TWO_PI * p.frameCount) / 200) * img.speedMagnet)
      );
      //fac = 1;

      let x_ = img.position.x * p.width;
      let x = p.mouseX + fac * (x_ - p.mouseX);

      let y_ = img.position.y * p.height;
      let y = p.mouseY + fac * (y_ - p.mouseY);

      const w =
        img.size.width *
        p.sin(p.HALF_PI * img.offset + (p.HALF_PI * p.frameCount) / 100);
      const h = w;

      p.push();

      p.translate(x, y);
      p.rotate(p.TWO_PI * ((p.frameCount / 50) * img.speed));
      p.translate(-x, -y);
      //console.log(p.mouseX, p.mouseY);
      p.image(img.imgData, x, y, w, h);
      p.pop();
    });
  };

  const toUnsigned = val => {
    return p.map(val, -1, 1, 0, 1);
  };
});
