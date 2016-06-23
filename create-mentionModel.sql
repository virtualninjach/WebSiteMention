USE [websiteMention]
GO

/****** Object:  Table [dbo].[mentionModel]    Script Date: 6/22/2016 8:53:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[mentionModel](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[WebSiteURL] [varchar](250) NOT NULL,
	[WebSiteAlias] [varchar](250) NOT NULL,
	[NameAlias] [varchar](250) NOT NULL,
	[MentionCount] [int] NOT NULL CONSTRAINT [DF_mentionModel_MentionCount]  DEFAULT ((0)),
	[timeStamp] [datetime] NULL CONSTRAINT [DF_mentionModel_timeStamp]  DEFAULT (getdate())
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


