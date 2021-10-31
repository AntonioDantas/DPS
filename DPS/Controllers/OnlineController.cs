using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DPS.Controllers
{
    public class OnlineController : Controller
    {
        // GET: Online
        public ActionResult Index()
        {
            return View();
        }

        
        public ActionResult OnlineAoVivo(string valor)
        {
            var objetos = new DAO.Online().Get();
            var list = JsonConvert.SerializeObject(objetos,
                        Formatting.None,
                        new JsonSerializerSettings()
                        {
                            ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
                        });

            return Content(list, "application/json");
        }

        public ActionResult RotaOnline(string cpf, string dia)
        {
            var objetos = new DAO.Online().GetCompleto(cpf,dia);
            var list = JsonConvert.SerializeObject(objetos,
                        Formatting.None,
                        new JsonSerializerSettings()
                        {
                            ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
                        });

            return Content(list, "application/json");
        }

        public ActionResult RondaVinculada(string cpf)
        {
            var objetos = new DAO.Online().GetRota(cpf);
            var list = JsonConvert.SerializeObject(objetos,
                        Formatting.None,
                        new JsonSerializerSettings()
                        {
                            ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
                        });

            return Content(list, "application/json");
        }

    }


}