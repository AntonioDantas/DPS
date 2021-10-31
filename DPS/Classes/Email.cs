using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Data.SqlClient;
using System.Net.Mail;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Text;
using System.Globalization;
using System.Net;
using System.Data;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Security.Cryptography;

namespace DPS.Classes
{
    public class Email
    {
        /// <summary>
        /// Envia um email.
        /// </summary>
        /// <returns>
        /// Sem retorno
        /// </returns>
        public static void enviaEmail(string destinatario, string titulo, string mensagem)
        {
            MailMessage obj = new MailMessage();
            obj.From = new MailAddress("dpsgrupo2@gmail.com");
            obj.To.Add(destinatario);
            obj.Priority = MailPriority.High;
            obj.IsBodyHtml = true;
            obj.Subject = titulo;
            obj.Body = mensagem;
            obj.SubjectEncoding = Encoding.GetEncoding("ISO-8859-1");
            obj.BodyEncoding = Encoding.GetEncoding("ISO-8859-1");
            
            SmtpClient cli = new SmtpClient("smtp.gmail.com", 465);
            //cli.DeliveryMethod = SmtpDeliveryMethod.PickupDirectoryFromIis;
            cli.EnableSsl = true;
            cli.Host = "smtp.gmail.com";
            cli.UseDefaultCredentials = false;
            cli.Credentials = new NetworkCredential("dpsgrupo2@gmail.com", "dps123456");
            cli.Send(obj);
        }

    }
}