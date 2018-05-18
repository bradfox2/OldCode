void lcd_printer(){
  
  if(remote_user_connected() && key != 1){
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Remote User      ");
    lcd.setCursor(0,1);
    lcd.print("Connected        ");
    key = 1;
  }
  
  else if(!remote_user_connected()){
    if(local_target_power() && key != 2){
      lcd.clear();
      lcd.print(input_pin_state);
      key = 2;
    }
    if(!local_target_power() && key !=3){
      lcd.clear();
      lcd.print(current_output_mode);
      key = 3;  
    }
  }
}

