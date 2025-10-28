abstract class Buff {
   private String name;
   private String className;
   private String description;
   private int turnTaken;
   
   Buff(String name, String className, String description, int turnTaken){
     this.name = name;
     this.className = className;
     this.description = description;
     this.turnTaken = turnTaken;
   }
   
   String getName() {
     return this.name;
   }
   
   abstract void activateBuff(GameCharacter target, String arg);
}
