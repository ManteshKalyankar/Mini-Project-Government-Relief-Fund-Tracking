// SPDX-License-Identifier: MIT

//BENEFICIARY.SOL


pragma solidity ^0.8.10;

contract FundDistribution
{
   struct beneficiaryDetails
   {
       string name;
       uint aadharNumber;
       uint phoneNumber;
       string location;
       uint pincode;
       uint bankAccountNumber;
       uint ifscNumber;
       uint accountBalance;
   } 
    
    mapping (uint => uint[])listOfAadharInAPincodeMap;
    
    mapping (uint => beneficiaryDetails)beneficiaryMap;

    uint256[] allBeneficiariesAadharNumber;


    function setBeneficiaryDetails(string memory _name,
                                    uint _aadharNumber,
                                    uint  _phoneNumber,
                                    string memory _location,
                                    uint _pincode,
                                    uint _bankAccountNumber
                                    )
    public
    {
        beneficiaryMap[_aadharNumber].name = _name;
        beneficiaryMap[_aadharNumber].aadharNumber = _aadharNumber;
        beneficiaryMap[_aadharNumber].phoneNumber = _phoneNumber;
        beneficiaryMap[_aadharNumber].location = _location;
        beneficiaryMap[_aadharNumber].pincode = _pincode;
        beneficiaryMap[_aadharNumber].bankAccountNumber = _bankAccountNumber;

        allBeneficiariesAadharNumber.push(_aadharNumber);  

        listOfAadharInAPincodeMap[_pincode].push(_aadharNumber);     
    }


    function getBeneficiaryDetails(uint _aadharNumber)

    view public returns (string memory, uint, uint, string memory, uint,  uint, uint)   
    {
        return
        (
            beneficiaryMap[_aadharNumber].name,
            beneficiaryMap[_aadharNumber].aadharNumber,
            beneficiaryMap[_aadharNumber].phoneNumber,
            beneficiaryMap[_aadharNumber].location,
            beneficiaryMap[_aadharNumber].pincode,
            beneficiaryMap[_aadharNumber].bankAccountNumber,
            beneficiaryMap[_aadharNumber].accountBalance
        );
    }


    function getAllAadharNumbers() view public returns(uint[] memory)
    {
        return allBeneficiariesAadharNumber;
    }


    function getCountOfBeneficiaries() view public returns (uint)
    {
        return allBeneficiariesAadharNumber.length; 
    }




//CENTRAL GOVERNMENT.SOL 


    struct centralsFundTransferingDetails
    {
        string stateName;
        string cause;
        uint bankAccountNumberOfCentral;
        uint bankAccountNumberOfState;
        uint ifscNumberOfStateBankAccount;
        uint transferingAmountOfCentral;
        uint centralsAccountNumberPin;
    }

    mapping (string  => centralsFundTransferingDetails)centralsFundTransferingDetailsMap;

    string[] allStates;


    //set function
    function setFundTransferingDetailsOfCentral(string memory _stateName, string memory _cause,
                        uint _bankAccountNumberOfCentral, uint _bankAccountNumberOfState,
                        uint _ifscNumberOfStateBankAccount, uint _transferingAmountOfCentral,uint _centralsAccountNumberPin)
    public
    {

        centralsFundTransferingDetailsMap[_stateName].stateName = _stateName;
        centralsFundTransferingDetailsMap[_stateName].cause = _cause;
        centralsFundTransferingDetailsMap[_stateName].bankAccountNumberOfCentral = _bankAccountNumberOfCentral;
        centralsFundTransferingDetailsMap[_stateName].bankAccountNumberOfState = _bankAccountNumberOfState;
        centralsFundTransferingDetailsMap[_stateName].ifscNumberOfStateBankAccount = _ifscNumberOfStateBankAccount;
        centralsFundTransferingDetailsMap[_stateName].transferingAmountOfCentral = _transferingAmountOfCentral;
        centralsFundTransferingDetailsMap[_stateName].centralsAccountNumberPin = _centralsAccountNumberPin;

        allStates.push(_stateName);

    }
    

    //get function
    function getTransferredFundDetailsOfCentral(string memory _stateName) view public 
    returns (string memory, string memory, uint, uint, uint,uint) 
    {
        return
        (
            centralsFundTransferingDetailsMap[_stateName].stateName,
            centralsFundTransferingDetailsMap[_stateName].cause,
            centralsFundTransferingDetailsMap[_stateName].bankAccountNumberOfCentral,
            centralsFundTransferingDetailsMap[_stateName].bankAccountNumberOfState,
            centralsFundTransferingDetailsMap[_stateName].ifscNumberOfStateBankAccount,
            centralsFundTransferingDetailsMap[_stateName].transferingAmountOfCentral
        );
    }

    //get function
    function getAllStatesList() view public returns(string[] memory)
    {
        return allStates;
    }




//STATE GOVERNMENT.SOL

    struct statesFundTransferingDetails
    {
        string stateName;
        string cause;
        uint bankAccountNumberOfState;
        uint ifscNumberOfStateBankAccount;
        uint transferingAmountOfState;
        uint statesAccountNumberPin;
        uint accountBalanceOfState;
    }

    mapping (string  => statesFundTransferingDetails)statesFundTransferingDetailsMap;


    //set function
    function setFundTransferingDetailsOfState(string memory _stateName, string memory _cause,
                        uint _bankAccountNumberOfState,uint _ifscNumberOfStateBankAccount,
                        uint _transferingAmountOfState,uint _statesAccountNumberPin)
    public
    {
        statesFundTransferingDetailsMap[_stateName].stateName = _stateName;
        statesFundTransferingDetailsMap[_stateName].cause = _cause;
        statesFundTransferingDetailsMap[_stateName].bankAccountNumberOfState = _bankAccountNumberOfState;
        statesFundTransferingDetailsMap[_stateName].ifscNumberOfStateBankAccount = _ifscNumberOfStateBankAccount;
        statesFundTransferingDetailsMap[_stateName].transferingAmountOfState = _transferingAmountOfState;
        statesFundTransferingDetailsMap[_stateName].statesAccountNumberPin = _statesAccountNumberPin;
        statesFundTransferingDetailsMap[_stateName].accountBalanceOfState += centralsFundTransferingDetailsMap[_stateName].transferingAmountOfCentral;
    }

    //get function
    function getTransferredFundDetailsOfState(string memory _stateName)view public
    returns(string memory ,string memory ,uint ,uint ,uint,uint)
    {
        return (
                    statesFundTransferingDetailsMap[_stateName].stateName,
                    statesFundTransferingDetailsMap[_stateName].cause,
                    statesFundTransferingDetailsMap[_stateName].bankAccountNumberOfState,
                    statesFundTransferingDetailsMap[_stateName].ifscNumberOfStateBankAccount,
                    statesFundTransferingDetailsMap[_stateName].transferingAmountOfState,
                    statesFundTransferingDetailsMap[_stateName].accountBalanceOfState
                    
                );
    }


    function setDistributionOfFund(string memory _stateName ,uint _pincode)
    public
    {
        
        uint countOfAllAadharInPincode = listOfAadharInAPincodeMap[_pincode].length;

        uint beneficiaryAmount = statesFundTransferingDetailsMap[_stateName].transferingAmountOfState / countOfAllAadharInPincode;
        
        if(statesFundTransferingDetailsMap[_stateName].transferingAmountOfState <= statesFundTransferingDetailsMap[_stateName].accountBalanceOfState)
        {

            for(uint i = 0; i<countOfAllAadharInPincode; i++)
            {

                uint _currentAadharNumberInLoop = listOfAadharInAPincodeMap[_pincode][i];

                beneficiaryMap[_currentAadharNumberInLoop].accountBalance += beneficiaryAmount;

                statesFundTransferingDetailsMap[_stateName].accountBalanceOfState -= beneficiaryAmount;
            
            }

        }

    }

}




