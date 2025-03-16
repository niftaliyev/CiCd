using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace CiCdDeployment.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class TestController : ControllerBase
    {
        [HttpGet("test")]
        public IActionResult Get()
        {
            return Ok("Hello World!");
        }
    }
}
