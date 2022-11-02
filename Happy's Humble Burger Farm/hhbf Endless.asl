//Thanks to Ero on the Speedrun Tool Dev Discord for asl-help and help with this.
state("Happy's Humble Burger Farm") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Happy's Humble Burger Farm";
	vars.startMoney = 0;
	vars.counter = 0;
}

init
{
  vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
  {
    var pm = "progressManager";
    var bfm = "burgerFarmManager";
    var ssls = "simStartLeverScript";

    vars.Helper["Scene"] = mono.MakeString(pm, "instance", "currentScene");
    vars.Helper["Money"] = mono.Make<int>(pm, "instance", "currency");
    vars.Helper["FarmOpen"] = mono.Make<bool>(bfm, "instance", "isOpen");
    vars.Helper["DinerOpen"] = mono.Make<bool>(ssls, "instance", "broken");
    return true;
  });

}

start
{
	return old.Scene == "Main Menu" && current.Scene != old.Scene && current.Scene != "Apartment";
}

onStart
{
		vars.startMoney = current.Money;
		vars.counter = 0;
}

update
{
  vars.Log(current.Scene);
  vars.Log(current.Money);
}

split
{
	if (current.Scene == "BurgerFarm" && current.FarmOpen && vars.counter < 1) {
		vars.counter = vars.counter + 1;
		return true;
	}
	if (current.Scene == "50s_Diner" && current.DinerOpen && vars.counter < 1) {
		vars.counter = vars.counter + 1;
		return true;
	}
	if (current.Money - vars.startMoney >= 100 && current.Money - vars.startMoney <= 199 && vars.counter < 2) {
		vars.counter = vars.counter + 1;
		return true;
	}
	if (current.Money - vars.startMoney >= 200 && current.Money - vars.startMoney <= 299 && vars.counter < 3) {
		vars.counter = vars.counter + 1;
		return true;
	}
	if (current.Money - vars.startMoney >= 300 && current.Money - vars.startMoney <= 399 && vars.counter < 4) {
		vars.counter = vars.counter + 1;
		return true;
	}
	if (current.Money - vars.startMoney >= 400 && current.Money - vars.startMoney <= 499 && vars.counter < 5) {
		vars.counter = vars.counter + 1;
		return true;
	}
	if (current.Money - vars.startMoney >= 500 && vars.counter < 6) {
		vars.counter = vars.counter + 1;
		return true;
	}
}

reset
{
	return old.Scene != "Main Menu" && current.Scene == "Main Menu";
}

onReset
{
  vars.counter = 0;
}
