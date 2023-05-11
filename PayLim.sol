// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract PayLim{

    mapping (address => uint256) public AmountSent;  // displays the amount sent by user
    mapping (address => int256) internal lvl; 

    address public admin;
    address[] internal Employees;
    uint public lvl_1_amt;
    uint public lvl_2_amt;
    uint public lvl_3_amt;
    
    
    constructor() {                    //to set the deployer as asmin
        admin = msg.sender;
    }
    
    modifier onlyadmin {
          require(msg.sender == admin,"YOU'RE UNAAUTHORISED");      //to give admin privilages to the functions
          _;
    }
    function Add_lvl_1_Emp (address emp_addr) onlyadmin public{
       require(lvl[emp_addr] != 1 && lvl[emp_addr] != 2 && lvl[emp_addr] != 3 && emp_addr != admin, "THIS ADDRESS HAS ALREADY ADDED");
       lvl[emp_addr]=1;
       Employees.push(emp_addr);
    }

    function Add_lvl_2_Emp (address emp_addr) onlyadmin public{
        require(lvl[emp_addr] != 1 && lvl[emp_addr] != 2 && lvl[emp_addr] != 3 && emp_addr != admin, "THIS ADDRESS HAS ALREADY ADDED");
        lvl[emp_addr]=2;
        Employees.push(emp_addr);
    }

    function Add_lvl_3_Emp (address emp_addr) onlyadmin public{
        require(lvl[emp_addr] != 1 && lvl[emp_addr] != 2 && lvl[emp_addr] != 3 && emp_addr != admin, "THIS ADDRESS HAS ALREADY ADDED");
        lvl[emp_addr]=3;
        Employees.push(emp_addr);
    }
    function Set_lvl_1_lim(uint amtInWei) onlyadmin public{
        lvl_1_amt = amtInWei;
    } 
     function Set_lvl_2_lim(uint amtInWei) onlyadmin public{
        lvl_2_amt = amtInWei;
    } 
     function Set_lvl_3_lim(uint amtInWei) onlyadmin public{
        lvl_3_amt = amtInWei;
    }

   function FindLvl(address _addr) public view returns(int LVL){
        if (_addr == admin)
          return 0;                                     //to show the  corresponding level of the employee
        else if (lvl[_addr]==1)
          return 1;
        else if (lvl[_addr]==2)
          return 2;
        else if (lvl[_addr]==3)
          return 3;
        else
          return -1;
   }
   function Pay(address payable recipient) payable public {  //establishing transaction for different levels
        if (msg.sender == admin){
           recipient.transfer(msg.value);                    
           AmountSent[admin] += msg.value;                        
        }

        else if (lvl[msg.sender] == 1){
           if ((AmountSent[msg.sender]+msg.value )<= lvl_1_amt){
             recipient.transfer(msg.value);
             AmountSent[msg.sender]+=msg.value;
           }
           else 
             revert("YOU'RE EXCEEDING YOUR TRANSACTION LIMIT");
        }
        else if (lvl[msg.sender] == 2){
           if ((AmountSent[msg.sender]+msg.value )<= lvl_2_amt){
             recipient.transfer(msg.value);
             AmountSent[msg.sender]+=msg.value;
           }
           else 
             revert("YOU'RE EXCEEDING YOUR TRANSACTION LIMIT");
        }

        else if (lvl[msg.sender] == 3){
           if ((AmountSent[msg.sender]+msg.value )<= lvl_3_amt){
             recipient.transfer(msg.value);
             AmountSent[msg.sender]+=msg.value;
           }
           else 
             revert("YOU'RE EXCEEDING YOUR TRANSACTION LIMIT"); //throws an error
        }
        else 
            revert("YOU CAN'T MAKE TRANSACTION");  //throws an error if a non employee makes transaction
   }
   

    function reset() onlyadmin public { //resetting all data
          lvl_1_amt=0;
          lvl_2_amt=0;
          lvl_3_amt=0;
          for (uint i=0; i<Employees.length;i++){ 
             AmountSent[Employees[i]]=0;
             lvl[Employees[i]]=-1;
          }
          AmountSent[admin]=0;
          Employees= new address[](0); 
          
    }
    function Del_Emp(address addr) onlyadmin public{             //deleting employee
        require(addr != admin,"YOU CAN'T REMOVE ADMIN USER");
        lvl[addr]=-1;
        for (uint i=0; i<Employees.length;i++){
          if (Employees[i] == addr){              //deleting employee address from Employees array
            Employees[i] = Employees[Employees.length-1]; 
            Employees.pop();
            break;
          }
        }
    }
    function ChangeAdmin(address addr) onlyadmin public{      //to change admin
      require(lvl[addr] != 1 && lvl[addr] != 2 && lvl[addr] != 3 );
      admin = addr;
    }
    function showEmployees() public view returns(address[] memory){ // to show all the present employees
      return Employees;
    }
    function resetTransactOfUser(address addr) onlyadmin public{
        require (lvl[addr] == 1 || lvl[addr] == 2 || lvl[addr] == 3 || addr == admin, "INVALID ADDRESS");
        AmountSent[addr] = 0;
    }
}