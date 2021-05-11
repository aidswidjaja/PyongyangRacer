package org.papervision3d.core.render.material
{
   import flash.utils.Dictionary;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   
   public class MaterialManager
   {
      
      private static var instance:MaterialManager;
       
      
      private var materials:Dictionary;
      
      public function MaterialManager()
      {
         super();
         if(instance)
         {
            throw new Error("Only 1 instance of materialmanager allowed");
         }
         this.init();
      }
      
      public static function registerMaterial(param1:MaterialObject3D) : void
      {
         getInstance()._registerMaterial(param1);
      }
      
      public static function unRegisterMaterial(param1:MaterialObject3D) : void
      {
         getInstance()._unRegisterMaterial(param1);
      }
      
      public static function getInstance() : MaterialManager
      {
         if(!instance)
         {
            instance = new MaterialManager();
         }
         return instance;
      }
      
      private function init() : void
      {
         this.materials = new Dictionary(true);
      }
      
      private function _registerMaterial(param1:MaterialObject3D) : void
      {
         this.materials[param1] = true;
      }
      
      private function _unRegisterMaterial(param1:MaterialObject3D) : void
      {
         delete this.materials[param1];
      }
      
      public function updateMaterialsBeforeRender(param1:RenderSessionData) : void
      {
         var _loc2_:IUpdateBeforeMaterial = null;
         var _loc3_:* = undefined;
         for(_loc3_ in this.materials)
         {
            if(_loc3_ is IUpdateBeforeMaterial)
            {
               _loc2_ = _loc3_ as IUpdateBeforeMaterial;
               if(_loc2_.isUpdateable())
               {
                  _loc2_.updateBeforeRender(param1);
               }
            }
         }
      }
      
      public function updateMaterialsAfterRender(param1:RenderSessionData) : void
      {
         var _loc2_:IUpdateAfterMaterial = null;
         var _loc3_:* = undefined;
         for(_loc3_ in this.materials)
         {
            if(_loc3_ is IUpdateAfterMaterial)
            {
               _loc2_ = _loc3_ as IUpdateAfterMaterial;
               _loc2_.updateAfterRender(param1);
            }
         }
      }
   }
}
