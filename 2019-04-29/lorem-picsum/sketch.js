const config = {
  countImgs: 30
};

new p5(function(p) {
  let imgs = [];

  for (let i = 0; i < config.countImgs; i++) {
    imgs[i] = { position: { x: p.random(), y: p.random() } };
  }

  p.preload = () => {
    const url = `https://picsum.photos/v2/list?page=2&limit=${
      config.countImgs
    }`;
    p.httpGet(url, result => {
      const items = JSON.parse(result);

      items.forEach((item, i) => {
        imgs[i].imgData = p.loadImage(item.download_url);
      });
    });
  };

  p.setup = () => {
    p.createCanvas(p.windowWidth, p.windowHeight);
  };

  p.draw = () => {
    //p.background(200);
    imgs.forEach(img => {
      if (!img.imgData) return;
      p.image(
        img.imgData,
        img.position.x * p.width,
        img.position.y * p.height,
        20,
        20
      );
    });
  };
});
