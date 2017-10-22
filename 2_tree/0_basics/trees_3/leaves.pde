class Leaf{
  boolean left;
  PShape leaf;
  
  Leaf(boolean left){      
    if(left){
      leaf = loadShape("TSQ-01-leaf01.svg");
    }    
    else{
      leaf = loadShape("TSQ-01-leaf02.svg");
    }    
  }
  
  void showLeaf(){  
    color line_g = color(127);
    leaf.setFill(line_g);
    shape(leaf, 3*plane_width - 1, height/2.5);
    //shape(leaf_l, 3*plane_width - leaf_l.width , height/2.5); 
  }
  
  void grow(){
    
 } 
  
}