using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Windows.Forms;
using System.Security.Cryptography;

namespace DPS.Classes
{
    public class Senha
    {

        /// <summary>
        /// Gera uma senha aleatória de 6 dígitos
        /// </summary>
        /// <returns>
        /// String aleatória
        /// </returns>
        public static string gerarSenha()
        {
            string validar = "abcdefghijklmnozABCDEFGHIJKLMNOZ1234567890@#$%&*!";
            try
            {
                StringBuilder strbld = new StringBuilder(100);
                Random random = new Random();
                int TamanhoDaSenha = 6;
                while (0 < TamanhoDaSenha--)
                {
                    strbld.Append(validar[random.Next(validar.Length)]);
                }
                return (strbld.ToString());
            }
            catch (Exception ex)
            {
                return "Erro : " + ex.Message;
            }
        }


        /// <summary>
        /// Criptografa uma string em MD5.
        /// </summary>
        /// <param name="input">
        /// Texto para realizar a conversão
        /// </param>
        /// <returns>
        /// Texto Criptrogafado
        /// </returns>
        public static string CalculateMD5Hash(string input)
        {
            // step 1, calculate MD5 hash from input
            MD5 md5 = System.Security.Cryptography.MD5.Create();
            byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
            byte[] hash = md5.ComputeHash(inputBytes);

            // step 2, convert byte array to hex string
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < hash.Length; i++)
            {
                sb.Append(hash[i].ToString("X2"));
            }
            return sb.ToString();
        }

    }
}