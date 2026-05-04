with ads_union as (                                        
                                                           
-- Facebook Ads verileri                                   
Select                                                     
ad_date,                                                   
'Facebook Ads' as media_source,                            
spend,                                                     
impressions,                                               
reach,                                                     
clicks,                                                    
leads,                                                     
value                                                      
from facebook_ads_basic_daily                              
                                                           
union all                                                  
                                                           
-- Google Ads verileri                                     
Select                                                     
ad_date,                                                   
'Google Ads' as media_source,                              
spend,                                                     
impressions,                                               
reach,                                                     
clicks,                                                    
leads,                                                     
value                                                      
From google_ads_basic_daily                                
                                                           
)                                                          
                                                           
Select                                                     
ad_date,                                                   
media_source,                                              
spend,                                                     
impressions,                                               
reach,                                                     
clicks,                                                    
leads,                                                     
value                                                      
From ads_union                                             
Order by                                                   
ad_date Desc,                                              
media_source;                                              
                                                           
                                                                                                                                                                                                                                                                                                      
                                                                                                                 
with ads_union (                                           
ad_date,                                                   
media_source,                                              
spend,                                                     
impressions,                                               
reach,                                                     
clicks,                                                    
leads,                                                     
value                                                      
) as (                                                     
                                                           
-- Facebook Ads verileri                                   
Select                                                     
ad_date,                                                   
'Facebook Ads' as media_source,                            
spend,                                                     
impressions,                                               
reach,                                                     
clicks,                                                    
leads,                                                     
value                                                      
From facebook_ads_basic_daily                              
                                                           
                                                           
Union all                                                  
                                                           
-- Google Ads verileri                                     
Select                                                     
ad_date,                                                   
'Google Ads' AS media_source,                              
spend,                                                     
impressions,                                               
reach,                                                     
clicks,                                                    
leads,                                                     
value                                                      
From google_ads_basic_daily                                
                                                           
)                                                          
                                                           
Select                                                     
ad_date,                                                   
media_source,                                              
SUM(spend)       as total_cost,                            
SUM(impressions) as total_impressions,                     
SUM(clicks)      as total_clicks,                          
SUM(value)       as total_conversion_value                 
From ads_union                                             
Group by                                                   
ad_date,                                                   
media_source                                               
Order by                                                   
ad_date DESC,                                              
media_source;                                              
