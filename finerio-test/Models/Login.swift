//
//  Login.swift
//
//  File Generated by macintoshhd on 07/09/2020.
//  Using model_gen.py
//

struct Login: Decodable {

	var username: String
	var roles: [String]
	var accessToken: String
	var expiresIn: Int
	var tokenType: String
	var refreshToken: String

}
