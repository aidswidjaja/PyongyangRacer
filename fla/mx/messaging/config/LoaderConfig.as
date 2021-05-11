package mx.messaging.config
{
   import flash.display.DisplayObject;
   import mx.core.mx_internal;
   import mx.utils.LoaderUtil;
   
   use namespace mx_internal;
   
   public class LoaderConfig
   {
      
      mx_internal static const VERSION:String = "4.0.0.14159";
      
      mx_internal static var _parameters:Object;
      
      mx_internal static var _swfVersion:uint;
      
      mx_internal static var _url:String = null;
       
      
      public function LoaderConfig()
      {
         super();
      }
      
      public static function init(param1:DisplayObject) : void
      {
         if(!mx_internal::_url)
         {
            _url = LoaderUtil.normalizeURL(param1.loaderInfo);
            _parameters = param1.loaderInfo.parameters;
            _swfVersion = param1.loaderInfo.swfVersion;
         }
      }
      
      public static function get parameters() : Object
      {
         return mx_internal::_parameters;
      }
      
      public static function get swfVersion() : uint
      {
         return mx_internal::_swfVersion;
      }
      
      public static function get url() : String
      {
         return mx_internal::_url;
      }
   }
}
