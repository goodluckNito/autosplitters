//Thanks to Ero and diggitydingdong for help with this.
state("Happy's Humble Burger Farm") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Happy's Humble Burger Farm";
	vars.startMoney = 0;
    // setup endless splits
	vars.Splits = new Dictionary<string, string>() {
    	{ "split_el_farm_open", "Split on opening the farm." },
    	{ "split_el_diner_open", "Split on opening the diner." },
   	{ "split_el_100", "Split on making $100." },
   	{ "split_el_200", "Split on making $200." },
  	{ "split_el_300", "Split on making $300." },
   	{ "split_el_400", "Split on making $400." },
   	};
  // putting this under endless split parent anticipating future merge with main asl
  settings.Add("endless_splits", false, "Endless% Splits");
  foreach(var split in vars.Splits.Keys)
  {
    settings.Add(split, false, vars.Splits[split], "endless_splits");
  }

  // ensures we don't split on the same condition twice
  vars.CompletedSplits = new Dictionary<string, bool>();
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
    vars.Helper["FarmOpen"] = mono.Make<bool>(bfm, "instance", "isOpen"); //open button in Farm
    vars.Helper["DinerOpen"] = mono.Make<bool>(ssls, "instance", "broken");//open lever in Diner
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
}

update
{
  vars.Log(current.Scene);
  vars.Log(current.Money);
}

split
{
  var moneyMade = current.Money - vars.startMoney;

//Split on opening the farm
  if (settings["split_el_farm_open"] && current.Scene == "BurgerFarm"
  && !old.FarmOpen && current.FarmOpen)
  {
    vars.CompletedSplits["split_el_farm_open"] = true;
    return true;
  }
//Split on opening the diner
  if (settings["split_el_diner_open"] && current.Scene == "50s_Diner"
  && !old.DinerOpen && current.DinerOpen)
  {
    vars.CompletedSplits["split_el_diner_open"] = true;
    return true;
  }
//Split every $100
  for (int i = 100; i <= moneyMade && i <= 500; i += 100)
  {
    var key = "split_el_" + i;
    if (!settings.ContainsKey(key) || (settings[key] && !vars.CompletedSplits[key]))
    {
      vars.CompletedSplits[key] = true;
      return true;
    }
  }
}

reset
{
  return old.Scene != "Main Menu" && current.Scene == "Main Menu";
}
