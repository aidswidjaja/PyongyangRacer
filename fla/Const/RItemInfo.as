package Const
{
   import org.papervision3d.core.math.NumberUV;
   
   public class RItemInfo
   {
      
      public static const BONUS:int = 0;
      
      public static const TREE1:int = 1;
      
      public static const TREE2:int = 2;
      
      public static const TREE3:int = 3;
      
      public static const HOUSE1:int = 4;
      
      public static const HOUSE2:int = 5;
      
      public static const HOUSE3:int = 6;
      
      public static const UMBRELLA1:int = 7;
      
      public static const UMBRELLA2:int = 8;
      
      public static const UMBRELLA3:int = 9;
      
      public static const SHELLFISH1:int = 10;
      
      public static const SHELLFISH2:int = 11;
      
      public static const STARFISH:int = 12;
      
      public static const CRAB:int = 13;
      
      public static const MOVINGWALL:int = 14;
      
      public static const BUS2:int = 15;
      
      public static var m_UVs:Array = new Array(new NumberUV(0,0),new NumberUV(1,0),new NumberUV(0,1),new NumberUV(1,1));
      
      public static var m_Tris:Array = new Array(new Array(2,1,0),new Array(2,3,1));
      
      private static var m_Tree1:Array = new Array(new Array(444,-40,-5),new Array(-444,-40,5),new Array(444,1000,-5),new Array(-444,1000,5));
      
      private static var m_Tree2:Array = new Array(new Array(250,-20,-5),new Array(-250,-20,5),new Array(250,600,-5),new Array(-250,600,5));
      
      private static var m_Tree3:Array = new Array(new Array(250,-20,-5),new Array(-250,-20,5),new Array(250,600,-5),new Array(-250,600,5));
      
      private static var m_House1:Array = new Array(new Array(509,-300,-5),new Array(-509,-300,5),new Array(509,572,-5),new Array(-509,572,5));
      
      private static var m_House2:Array = new Array(new Array(608,-300,-5),new Array(-608,-300,5),new Array(608,650,-5),new Array(-608,650,5));
      
      private static var m_House3:Array = new Array(new Array(530,-70,-5),new Array(-530,-70,5),new Array(530,700,-5),new Array(-530,700,5));
      
      private static var m_Umbrella1:Array = new Array(new Array(400,0,-5),new Array(-400,0,5),new Array(400,500,-5),new Array(-400,500,5));
      
      private static var m_Umbrella2:Array = new Array(new Array(200,0,-5),new Array(-200,0,5),new Array(200,300,-5),new Array(-200,300,5));
      
      private static var m_Umbrella3:Array = new Array(new Array(150,0,-5),new Array(-150,0,5),new Array(150,310,-5),new Array(-150,310,5));
      
      private static var m_ShellFish1:Array = new Array(new Array(70,-20,-5),new Array(-70,-20,5),new Array(70,60,-5),new Array(-70,60,5));
      
      private static var m_ShellFish2:Array = new Array(new Array(70,-20,-5),new Array(-70,-20,5),new Array(70,60,-5),new Array(-70,60,5));
      
      private static var m_StarFish:Array = new Array(new Array(70,-20,-5),new Array(-70,-20,5),new Array(70,60,-5),new Array(-70,60,5));
      
      private static var m_Crab:Array = new Array(new Array(100,-20,-5),new Array(-100,-20,5),new Array(100,110,-5),new Array(-100,110,5));
       
      
      public function RItemInfo()
      {
         super();
      }
      
      public static function GetVtxs(param1:int) : Array
      {
         switch(param1)
         {
            case TREE1:
               return m_Tree1;
            case TREE2:
               return m_Tree2;
            case TREE3:
               return m_Tree3;
            case HOUSE1:
               return m_House1;
            case HOUSE2:
               return m_House2;
            case HOUSE3:
               return m_House3;
            case UMBRELLA1:
               return m_Umbrella1;
            case UMBRELLA2:
               return m_Umbrella2;
            case UMBRELLA3:
               return m_Umbrella3;
            case SHELLFISH1:
               return m_ShellFish1;
            case SHELLFISH2:
               return m_ShellFish2;
            case STARFISH:
               return m_StarFish;
            case CRAB:
               return m_Crab;
            default:
               return null;
         }
      }
      
      public static function GetTextureName(param1:int) : String
      {
         switch(param1)
         {
            case TREE1:
               return "Resource/texture/tree.png";
            case TREE2:
               return "Resource/texture/tree1.png";
            case TREE3:
               return "Resource/texture/tree1.png";
            case HOUSE1:
               return "Resource/texture/21.png";
            case HOUSE2:
               return "Resource/texture/house2.png";
            case HOUSE3:
               return "Resource/texture/house3.png";
            case UMBRELLA1:
               return "Resource/texture/drink.png";
            case UMBRELLA2:
               return "Resource/texture/usan.PNG";
            case UMBRELLA3:
               return "Resource/texture/usan2.PNG";
            case SHELLFISH1:
               return "Resource/texture/cell1.png";
            case SHELLFISH2:
               return "Resource/texture/cell2.PNG";
            case STARFISH:
               return "Resource/texture/cell3.PNG";
            case CRAB:
               return "Resource/texture/cell4.png";
            default:
               return "";
         }
      }
   }
}
