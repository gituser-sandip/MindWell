package com.mindwell.model;

public class UserModel {
    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String city;
    private String userType;
    private String requestedUserType;
    private String accountStatus;
    private String createdAt;
    
    public UserModel() {}
    
    public UserModel(String fullName, String email, String password, String phone, String city) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.city = city;
        this.userType = "user";
        this.requestedUserType = "user";
        this.accountStatus = "pending";
    }
    
    public int getUserId() 
    { 
    	return userId; 
    }
    public void setUserId(int userId) 
    {
    	this.userId = userId; 
    	
    }
    public String getFullName() 
    { 
    	return fullName; 
    	
    }
    public void setFullName(String fullName) 
    { 
    	this.fullName = fullName; 
    	
    }
    public String getEmail() 
	{ 
    	return email; 
    	
	}
    public void setEmail(String email) 
	{
    	this.email = email;
    	
	}
    public String getPassword() 
	{ 
    	return password; 
    	
	}
    public void setPassword(String password) 
	{
    	this.password = password; 
    	
	}
    public String getPhone() 
	{ 
    	return phone; 
	
	}
    public void setPhone(String phone) 
    { 
    	this.phone = phone;
    	
	}
    public String getCity() 
	{ 
    	return city; 
	
	}
    public void setCity(String city) 
	{ 
    	this.city = city; 
    	
	}
    public String getUserType() 
	{ 
    	return userType; 
    	
	}
    public void setUserType(String userType) 
	{ 
    	this.userType = userType; 
	
	}
    public String getRequestedUserType()
    {
        return requestedUserType;
    }
    public void setRequestedUserType(String requestedUserType)
    {
        this.requestedUserType = requestedUserType;
    }
    public String getAccountStatus()
    {
        return accountStatus;
    }
    public void setAccountStatus(String accountStatus)
    {
        this.accountStatus = accountStatus;
    }
    public String getCreatedAt() 
	{ 
    	return createdAt; 
	
	}
    public void setCreatedAt(String createdAt) 
	{
    	this.createdAt = createdAt; 
    	
	}
}
