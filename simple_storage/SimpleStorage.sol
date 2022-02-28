// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract SimpleStorage {
    uint256 favoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People public person = People({favoriteNumber: 2, name: "Nitin"});

    People[] public arrPeople;
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }
    function addPerson(uint256 _favoriteNumber, string memory _name) public {
        arrPeople.push(People(_favoriteNumber, _name));
        //arrPeople.push(People({favoriteNumber: _favoriteNumber, name: _name}));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}