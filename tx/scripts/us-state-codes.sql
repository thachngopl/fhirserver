CREATE TABLE [dbo].[USStateCodes](
	[Display] [nchar](255) NOT NULL,
	[Code] [nchar](10) NOT NULL,
 CONSTRAINT [PK_USStateCodes] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

insert into USStateCodes (Code, Display) values ('AK', 'Alaska')
insert into USStateCodes (Code, Display) values ('AL', 'Alabama')
insert into USStateCodes (Code, Display) values ('AR', 'Arkansas')
insert into USStateCodes (Code, Display) values ('AS', 'American Samoa')
insert into USStateCodes (Code, Display) values ('AZ', 'Arizona')
insert into USStateCodes (Code, Display) values ('CA', 'California')
insert into USStateCodes (Code, Display) values ('CO', 'Colorado')
insert into USStateCodes (Code, Display) values ('CT', 'Connecticut')
insert into USStateCodes (Code, Display) values ('DC', 'District of Columbia')
insert into USStateCodes (Code, Display) values ('DE', 'Delaware')
insert into USStateCodes (Code, Display) values ('FL', 'Florida')
insert into USStateCodes (Code, Display) values ('FM', 'Federated States of Micronesia')
insert into USStateCodes (Code, Display) values ('GA', 'Georgia')
insert into USStateCodes (Code, Display) values ('GU', 'Guam')
insert into USStateCodes (Code, Display) values ('HI', 'Hawaii')
insert into USStateCodes (Code, Display) values ('IA', 'Iowa')
insert into USStateCodes (Code, Display) values ('ID', 'Idaho')
insert into USStateCodes (Code, Display) values ('IL', 'Illinois')
insert into USStateCodes (Code, Display) values ('IN', 'Indiana')
insert into USStateCodes (Code, Display) values ('KS', 'Kansas')
insert into USStateCodes (Code, Display) values ('KY', 'Kentucky')
insert into USStateCodes (Code, Display) values ('LA', 'Louisiana')
insert into USStateCodes (Code, Display) values ('MA', 'Massachusetts')
insert into USStateCodes (Code, Display) values ('MD', 'Maryland')
insert into USStateCodes (Code, Display) values ('ME', 'Maine')
insert into USStateCodes (Code, Display) values ('MH', 'Marshall Islands')
insert into USStateCodes (Code, Display) values ('MI', 'Michigan')
insert into USStateCodes (Code, Display) values ('MN', 'Minnesota')
insert into USStateCodes (Code, Display) values ('MO', 'Missouri')
insert into USStateCodes (Code, Display) values ('MP', 'Northern Mariana Islands')
insert into USStateCodes (Code, Display) values ('MS', 'Mississippi')
insert into USStateCodes (Code, Display) values ('MT', 'Montana')
insert into USStateCodes (Code, Display) values ('NC', 'North Carolina')
insert into USStateCodes (Code, Display) values ('ND', 'North Dakota')
insert into USStateCodes (Code, Display) values ('NE', 'Nebraska')
insert into USStateCodes (Code, Display) values ('NH', 'New Hampshire')
insert into USStateCodes (Code, Display) values ('NJ', 'New Jersey')
insert into USStateCodes (Code, Display) values ('NM', 'New Mexico')
insert into USStateCodes (Code, Display) values ('NV', 'Nevada')
insert into USStateCodes (Code, Display) values ('NY', 'New York')
insert into USStateCodes (Code, Display) values ('OH', 'Ohio')
insert into USStateCodes (Code, Display) values ('OK', 'Oklahoma')
insert into USStateCodes (Code, Display) values ('OR', 'Oregon')
insert into USStateCodes (Code, Display) values ('PA', 'Pennsylvania')
insert into USStateCodes (Code, Display) values ('PR', 'Puerto Rico')
insert into USStateCodes (Code, Display) values ('PW', 'Palau')
insert into USStateCodes (Code, Display) values ('RI', 'Rhode Island')
insert into USStateCodes (Code, Display) values ('SC', 'South Carolina')
insert into USStateCodes (Code, Display) values ('SD', 'South Dakota')
insert into USStateCodes (Code, Display) values ('TN', 'Tennessee')
insert into USStateCodes (Code, Display) values ('TX', 'Texas')
insert into USStateCodes (Code, Display) values ('UM', 'U.S. Minor Outlying Islands')
insert into USStateCodes (Code, Display) values ('UT', 'Utah')
insert into USStateCodes (Code, Display) values ('VA', 'Virginia')
insert into USStateCodes (Code, Display) values ('VI', 'Virgin Islands of the U.S.')
insert into USStateCodes (Code, Display) values ('VT', 'Vermont')
insert into USStateCodes (Code, Display) values ('WA', 'Washington')
insert into USStateCodes (Code, Display) values ('WI', 'Wisconsin')
insert into USStateCodes (Code, Display) values ('WV', 'West Virginia')
insert into USStateCodes (Code, Display) values ('WY', 'Wyoming')
