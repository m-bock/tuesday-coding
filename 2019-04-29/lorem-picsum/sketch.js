// Global configuration
const config = {
  countImgs: 20,
  maxImgSize: 1 / 20
};

new p5(p => {
  let particles = [];

  // Load images from the lorem picsum API
  const loadImages = () => {
    const urlImgList = "https://picsum.photos/v2/list?page=2&limit=1000";

    // Receive a list of images from the API
    p.httpGet(urlImgList).then(rawData => {
      const data = JSON.parse(rawData);
      const items = p.shuffle(data).slice(0, config.countImgs);

      // Augment the particles with images from the API
      items.forEach((item, i) => {
        const width = p.round(p.width * config.maxImgSize);
        const height = width;
        const imgUrl = `https://picsum.photos/id/${item.id}/${width}/${height}`;
        particles[i].imgData = p.loadImage(imgUrl);
        particles[i].size = { width, height };
      });
    });
  };

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
    loadImages();
  };

  p.setup = () => {
    p.createCanvas(p.windowWidth, p.windowHeight);

    // Start with mouse variables in the center
    p.mouseX = p.windowWidth / 2;
    p.mouseY = p.windowHeight / 2;

    p.imageMode(p.CENTER);

    // Initalize the particles with random properties
    for (let i = 0; i < config.countImgs; i++) {
      particles[i] = new Particle({
        position: { x: p.random(), y: p.random() },
        speed: p.random([p.random(-1, -0.5), p.random(0.5, 1)]),
        speedMagnet: p.random(0.5, 1),
        offset: p.random()
      });
    }

    loadImages();
  };

  p.draw = () => {
    p.background(220);

    // Draw all particles
    particles.forEach(particle => {
      particle.draw(p);
    });
  };
});
