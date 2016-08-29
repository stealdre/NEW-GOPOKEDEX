//
//  ChargeMove.swift
//  Go Pokedex
//
//  Created by antoine beneteau on 23/08/2016.
//  Copyright © 2016 Anna. All rights reserved.
//

import UIKit

class ChargeMove {
    private var _id: String!
    private var _name: String!
    private var _typeString: String!
    private var _type: Type
    private var _cooldown: String!
    private var _trueDps: String!
    private var _energyCost: String!
    private var _pow: String!
    private var _crit: String!
    private var _damageFullCharge: String!
    private var _damage1Charge: String!
    
    
    var id: String {
        if _id == nil {
            _id = "?"
        }
        return _id
    }
    
    var name: String {
        if _name == nil {
            _name = "?"
        }
        return _name.capitalizedString
    }
    
    var type: Type {
        return _type
    }
    
    var typeString: String {
        return _typeString
    }
    
    var cooldown: String {
        if _cooldown == nil {
            _cooldown = "?"
        }
        return _cooldown
    }
    
    var trueDps: String {
        if _trueDps == nil {
            _trueDps = "?"
        }
        return _trueDps
    }
    
    var energyCost: String {
        if _energyCost == nil {
            _energyCost = "?"
        }
        return _energyCost
    }
    
    var damageFullCharge: String {
        if _damageFullCharge == nil {
            _damageFullCharge = "?"
        }
        return _damageFullCharge
    }
    
    var damage1Charge: String {
        if _damage1Charge == nil {
            _damage1Charge = "?"
        }
        return _damage1Charge
    }
    
    
    var pow: String {
        if _pow == nil {
            _pow = "?"
        }
        return _pow
    }
    
    var crit: String {
        if _crit == nil {
            _crit = "?"
        }
        return _crit
    }
    
    
    init() {
        self._type = Type()
    }
    
    init(id: String, name: String) {
        self._id = id
        self._name = name
        self._type = Type()
    }
    
    func initSpecies(cooldown: String, trueDps: String, energyCost: String, pow: String, crit: String, damageFullCharge: String, damage1Charge: String, typeString: String) {
        self._cooldown = cooldown
        self._trueDps = trueDps
        self._energyCost = energyCost
        self._pow = pow
        self._crit = crit
        self._damageFullCharge = damageFullCharge
        self._damage1Charge = damage1Charge
        self._typeString = typeString
    }
    
    func addType(type: Type) {
        self._type = type
    }

}

func initAllChargeMoves() -> [ChargeMove]{
    let chargeMovesCSV = CSVReader(fileName: "GoPokedex_ChargeMovesFinal")
    var chargeMovesList = [ChargeMove]()
    chargeMovesList.removeAll()
    for row in chargeMovesCSV.rows {
        let chargeMove = ChargeMove(id: row["ID"]!, name: row["Name"]!)
        chargeMove.initSpecies(row["Duration (ms)"]!, trueDps: row["(PW) DPS"]!, energyCost: row["NRG Cost"]!, pow: row["PW"]!, crit: row["Crit%"]!, damageFullCharge: row["(PW) Damage from Full Energy"]!, damage1Charge: row["(PW) DPS w/ 1s Charge"]!, typeString: row["Type"]!)
        chargeMovesList.append(chargeMove)
    }
    return chargeMovesList
}


func addChargeMoves(pokemonList: [Pokemon], chargeMoveList: [ChargeMove]) {
    for pokemon in pokemonList {
        for chargeMoveString in pokemon.chargeMovesString {
            for chargeMove in chargeMoveList {
                if chargeMoveString == chargeMove.name{
                    pokemon.addChargeMove(chargeMove)
                    continue
                }
            }
        }
    }
}

func addTypes(chargeMoveList: [ChargeMove], typeList: [Type]) {
    for chargeMove in chargeMoveList {
        for type in typeList {
            if chargeMove.typeString == type.name {
                chargeMove.addType(type)
                continue
            }
        }
    }
}






