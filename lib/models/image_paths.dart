class ImagePath {
  String imgPath;
  bool status;

  ImagePath({this.imgPath, this.status});
}

/*
- assets/images/walk.jpg
    - assets/images/sky.jpg
    - assets/images/space.jpg
    - assets/images/sea.jpg
    - assets/images/peri.jpg

*/
List<ImagePath> imagePath = [
  ImagePath(imgPath: "assets/images/walk.jpg", status: false),
  ImagePath(imgPath: "assets/images/space.jpg", status: false),
  ImagePath(imgPath: "assets/images/sky.jpg", status: false),
  ImagePath(imgPath: "assets/images/sea.jpg", status: false),
  ImagePath(imgPath: "assets/images/peri.jpg", status: false),
  ImagePath(imgPath: "assets/images/def.jpg", status: false),
  ImagePath(imgPath: "assets/images/black.jpg", status: false),
];
