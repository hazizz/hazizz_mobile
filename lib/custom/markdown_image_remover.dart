String markdownImageRemover(String description){
  
  int i = description.indexOf("![hazizz_image](");

  print("index212: ${i.toString()}");

  if(i == -1) return description;

  String s =  description.substring(0, i);

  return s;
}