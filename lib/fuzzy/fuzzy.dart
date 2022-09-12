class fuzzyData {
  late List<String> plantData;
  //retunr list
  List<String> getPlantData(double temp, double ph, int hum) {
    if(ph >= 6 && ph<= 6.20 && hum >= 67 && hum <=90 && temp >= 26 && temp<=26.2)
    {
      plantData = ["Blewah","Wortel","Talas"];
    }
    else if(ph >= 6 && ph<= 6.20 && hum >= 30 && hum <=80 && temp >= 26 && temp<=26.2)
    {
      plantData = ["Cabai","Terong","Tomat","Kedelai","Karet","Tebu"];
    }
    else if(ph >= 6 && ph<= 6.1 && hum >= 50 && hum <=58 && temp >= 26 && temp<=26.2)
    {
      plantData = ["Timun","Kacang Tanah","Tomat","Melon","Tembakau"];
    }
    else if(ph >= 6.06 && ph<= 6.13 && hum >= 40 && hum <=72 && temp >= 26 && temp<=26.15)
    {
      plantData = ["Kedelai","Karet","Tebu","Cabai","Terong","Tomat"];
    }
    else if(ph >= 6.00 && ph<= 7.00 && hum >= 70 && hum <=85 && temp >= 26 && temp<=27)
    {
      plantData = ["Padi","Ketan","Tebu"];
    }
    else
    {
      plantData = ["Ketela","Umbi"];
    }
    return plantData;
  }
  

}