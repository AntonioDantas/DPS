using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DPS.Controllers
{
    public class FuncionarioController : Controller
    {
        // GET: Funcionario
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Login(string cpf, string senha)
        {
            var objetos = new DAO.Funcionario().Login(cpf, senha);
            var list = JsonConvert.SerializeObject(objetos,
                        Formatting.None,
                        new JsonSerializerSettings()
                        {
                            ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
                        });

            return Content(list, "application/json");
        }

        public ActionResult GravarLocalizacao(string cpf, string lat, string lng)
        {
            var objetos = new DAO.Funcionario().GravarLocalizacao(cpf, lat, lng);
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