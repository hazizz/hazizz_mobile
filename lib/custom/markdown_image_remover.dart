String markdownImageRemover(String description){
  
  int i = description.indexOf("![hazizz_image](");

  if(i == -1) return description;

  String s =  description.substring(0, i);

  return s;
}