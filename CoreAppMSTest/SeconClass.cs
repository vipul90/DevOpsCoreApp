using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Text;

namespace CoreAppMSTest
{
    [TestClass]
    public class SeconClass
    {
        [TestMethod]
        public void FirstSecond()
        {
            var test = 10;
            Assert.AreEqual(test, 10);
        }

        [TestMethod]
        public void SecondSecond()
        {
            Assert.IsTrue(true);
        }
    }
}
