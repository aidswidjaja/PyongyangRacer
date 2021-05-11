package org.papervision3d
{
   import org.papervision3d.core.log.PaperLogger;
   
   public class Papervision3D
   {
      
      public static var useDEGREES:Boolean = true;
      
      public static var usePERCENT:Boolean = false;
      
      public static var useRIGHTHANDED:Boolean = false;
      
      public static var NAME:String = "Papervision3D";
      
      public static var VERSION:String = "2.0.0";
      
      public static var DATE:String = "March 12th, 2009";
      
      public static var AUTHOR:String = "(c) 2006-2008 Copyright by Carlos Ulloa | John Grden | Ralph Hauwert | Tim Knip | Andy Zupko";
      
      public static var PAPERLOGGER:PaperLogger = PaperLogger.getInstance();
       
      
      public function Papervision3D()
      {
         super();
      }
   }
}
