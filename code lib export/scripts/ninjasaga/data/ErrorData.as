package ninjasaga.data
{
   public class ErrorData
   {
      
      public static const CODE_SESSION_TIMEOUT:String = "100";
      
      public static const CODE_SERVER_MAINTAINANCE:String = "110";
      
      public static const CODE_CLIEN_VERSION_REJECTED:String = "102";
      
      public static const CODE_AMF_CONNECTION_ERROR:String = "2000";
      
      public static const CODE_AMF_CONNECTION_REFUSED:String = "2001";
      
      public static const CODE_CHARACTER_SKILL_INVALID:String = "2101";
       
      
      public function ErrorData()
      {
         super();
      }
      
      public static function getErrorString(code:String) : String
      {
         var ErrorMessage:Array = null;
         ErrorMessage = [{"text":"<br>Your session has been timed out. Please reload this page to login again."},{"text":"<br>The server is under maintainance. Please come back later."},{"text":"<br>Your game client version is out of date. Please refresh this web page to reload the latest version of Ninja Saga game."},{"text":"<br>Your character is disabled because hacking activities are detected. To start the game, delete your character and create a new one."},{"text":"<br>Sorry, you have lost connection to the server. You may resolve it by [<a href=\'http://ninjasaga.com/support/troubleshooting.php?section=get_error_2000\' target=\'_blank\'><font color=\'#00FFFF\'><u>Clear Cache</u></font></a>]."}];
         switch(AppData.lang)
         {
            case AppData.ZH:
               ErrorMessage[0].text = "<br>你的登錄階段己逾期，請重新登入。";
               ErrorMessage[1].text = "<br>伺服器正進行維護，請稍後再登入。";
               ErrorMessage[2].text = "<br>你的程式版本己過期，請刷新網頁自動更新忍者傳說最新版本。";
               ErrorMessage[3].text = "<br>系統偵測到非法入侵記錄，你的遊戲角色已被禁用。要開始遊戲，請刪除角色及創建新角色。";
               ErrorMessage[4].text = "<br>網絡連接失敗，請檢查你的網絡是否正常，然後刷新本頁面重試。<br>你可以嘗試以[<a href=\'http://ninjasaga.com/support/troubleshooting.php?section=get_error_2000\' target=\'_blank\'><font color=\'#00FFFF\'><u>清除瀏覽器</u></font></a>]解決。";
               break;
            case AppData.ES:
               ErrorMessage[0].text = "<br>Tu sesion ha caducado. Actualiza esta pagina para entrar de nuevo .";
               ErrorMessage[1].text = "<br>El servidor esta en mantenimiento. Por favor, regresa mas tarde.";
               ErrorMessage[2].text = "<br>Por favor, actualiza esta pagina para cargar la ultima version del juego Ninja Saga.";
               ErrorMessage[3].text = "<br>Tu Ninja ha sido desactivado debido a que fueron detectadas actividades ilicitas. Para comenzar a jugar debes eliminar este Ninja y crear uno nuevo.";
               ErrorMessage[4].text = "<br>La conexion ha fallado. Usted puede resolverla por [<a href=\'http://ninjasaga.com/support/troubleshooting.php?section=get_error_2000\' target=\'_blank\'><font color=\'#00FFFF\'><u>Clear Cache</u></font></a>].";
         }
         switch(code)
         {
            case CODE_SESSION_TIMEOUT:
               return ErrorMessage[0].text;
            case CODE_SERVER_MAINTAINANCE:
               return ErrorMessage[1].text;
            case CODE_CLIEN_VERSION_REJECTED:
               return ErrorMessage[2].text;
            case "1100":
               return ErrorMessage[3].text;
            default:
               return ErrorMessage[4].text;
         }
      }
   }
}
