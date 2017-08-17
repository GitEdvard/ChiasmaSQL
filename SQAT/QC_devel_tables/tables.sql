
USE [QC_practice]
GO
/****** Object:  Table [dbo].[annotation]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[annotation](
	[annotation_id] [int] IDENTITY(1,1) NOT NULL,
	[annotation_type_id] [int] NOT NULL,
	[value] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[annotation_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[annotation_link]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[annotation_link](
	[marker_id] [int] NOT NULL,
	[annotation_id] [int] NOT NULL,
 CONSTRAINT [annotation_link_PK] PRIMARY KEY CLUSTERED 
(
	[marker_id] ASC,
	[annotation_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[annotation_type]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[annotation_type](
	[annotation_type_id] [int] IDENTITY(1,1) NOT NULL,
	[identifier] [varchar](255) NOT NULL,
	[description] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[annotation_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identifier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[application_version]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[application_version](
	[version_id] [int] NOT NULL,
	[identifier] [varchar](255) NOT NULL,
	[version] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[version_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[assay]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[assay](
	[assay_id] [int] NOT NULL,
	[identifier] [varchar](255) NOT NULL,
	[marker_id] [int] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[assay_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identifier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[authority]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[authority](
	[authority_id] [int] NOT NULL,
	[identifier] [varchar](255) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[user_type] [varchar](32) NOT NULL,
	[account_status] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[authority_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identifier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[denorm_genotype]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[denorm_genotype](
	[genotype_id] [int] NOT NULL,
	[sample_id] [int] NOT NULL,
	[individual_id] [int] NOT NULL,
	[assay_id] [int] NOT NULL,
	[marker_id] [int] NOT NULL,
	[alleles] [char](3) NOT NULL,
	[status_id] [tinyint] NOT NULL,
	[plate_id] [int] NOT NULL,
	[pos_x] [tinyint] NULL,
	[pos_y] [tinyint] NULL,
	[locked_wset_id] [int] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[genotype_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[individual]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[individual](
	[individual_id] [int] NOT NULL,
	[identifier] [varchar](255) NOT NULL,
	[individual_type_id] [tinyint] NOT NULL,
	[sex_id] [tinyint] NOT NULL,
	[father_id] [int] NULL,
	[mother_id] [int] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[individual_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identifier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[individual_type]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[individual_type](
	[individual_type_id] [tinyint] NOT NULL,
	[name] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[individual_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[kind]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[kind](
	[kind_id] [tinyint] NOT NULL,
	[name] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[kind_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[marker]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[marker](
	[marker_id] [int] NOT NULL,
	[identifier] [varchar](255) NOT NULL,
	[chrom_name] [varchar](20) NULL,
	[allele_variant] CHAR(3) NULL,
PRIMARY KEY CLUSTERED 
(
	[marker_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identifier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[permission]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permission](
	[project_id] [int] NOT NULL,
	[authority_id] [int] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[project_id] ASC,
	[authority_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[plate]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[plate](
	[plate_id] [int] NOT NULL,
	[identifier] [varchar](255) NOT NULL,
	[project_id] [int] NULL,
	[authority_id] [int] NOT NULL,
	[created] [datetime] NOT NULL DEFAULT (getdate()),
	[description] [varchar](255) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[plate_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identifier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[project]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[project](
	[project_id] [int] NOT NULL,
	[identifier] [varchar](255) NOT NULL,
	[comment] [varchar](1024) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[project_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identifier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[reference_genotype]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[reference_genotype](
	[item] [varchar](255) NOT NULL,
	[experiment] [varchar](255) NOT NULL,
	[alleles] [char](3) NOT NULL,
	[reference_set_id] [tinyint] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[reference_set]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[reference_set](
	[reference_set_id] [tinyint] NOT NULL,
	[identifier] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[reference_set_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identifier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[sample]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sample](
	[sample_id] [int] NOT NULL,
	[identifier] [varchar](255) NOT NULL,
	[individual_id] [int] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[sample_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identifier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[session_setting]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[session_setting](
	[session_setting_id] [int] IDENTITY(1,1) NOT NULL,
	[key_name] [varchar](255) NOT NULL,
	[subkey] [varchar](255) NOT NULL,
	[value_char] [varchar](255) NULL,
	[value_int] [int] NULL,
	[value_dec] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[session_setting_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [session_setting_UQ] UNIQUE NONCLUSTERED 
(
	[key_name] ASC,
	[subkey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[sex]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sex](
	[sex_id] [tinyint] NOT NULL,
	[name] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sex_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[status]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[status](
	[status_id] [tinyint] NOT NULL,
	[name] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[status_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[status_log]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[status_log](
	[status_log_id] [int] IDENTITY(1,1) NOT NULL,
	[genotype_id] [int] NOT NULL,
	[old_status_id] [tinyint] NOT NULL,
	[new_status_id] [tinyint] NOT NULL,
	[authority_id] [int] NOT NULL,
	[created] [datetime] NOT NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[status_log_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[wset]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[wset](
	[wset_id] [int] NOT NULL,
	[identifier] [varchar](255) NOT NULL,
	[authority_id] [int] NOT NULL,
	[wset_type_id] [tinyint] NOT NULL,
	[project_id] [int] NULL,
	[created] [datetime] NOT NULL DEFAULT (getdate()),
	[description] [varchar](255) NULL,
	[deleted] [bit] NOT NULL DEFAULT ((0)),
PRIMARY KEY NONCLUSTERED 
(
	[wset_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identifier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[wset_member]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wset_member](
	[identifiable_id] [int] NOT NULL,
	[kind_id] [tinyint] NOT NULL,
	[wset_id] [int] NOT NULL,
 CONSTRAINT [wset_member_PK] PRIMARY KEY CLUSTERED 
(
	[identifiable_id] ASC,
	[kind_id] ASC,
	[wset_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[wset_type]    Script Date: 11/20/2009 16:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[wset_type](
	[wset_type_id] [tinyint] NOT NULL,
	[name] [varchar](255) NOT NULL,
	[description] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[wset_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[annotation]  WITH CHECK ADD  CONSTRAINT [annotation_annotation_type_FK] FOREIGN KEY([annotation_type_id])
REFERENCES [dbo].[annotation_type] ([annotation_type_id])
GO
ALTER TABLE [dbo].[annotation] CHECK CONSTRAINT [annotation_annotation_type_FK]
GO
ALTER TABLE [dbo].[annotation_link]  WITH CHECK ADD  CONSTRAINT [annotation_link_annotation_FK] FOREIGN KEY([annotation_id])
REFERENCES [dbo].[annotation] ([annotation_id])
GO
ALTER TABLE [dbo].[annotation_link] CHECK CONSTRAINT [annotation_link_annotation_FK]
GO
ALTER TABLE [dbo].[annotation_link]  WITH CHECK ADD  CONSTRAINT [annotation_link_marker_FK] FOREIGN KEY([marker_id])
REFERENCES [dbo].[marker] ([marker_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[annotation_link] CHECK CONSTRAINT [annotation_link_marker_FK]
GO
ALTER TABLE [dbo].[assay]  WITH CHECK ADD  CONSTRAINT [assay_marker_FK] FOREIGN KEY([marker_id])
REFERENCES [dbo].[marker] ([marker_id])
GO
ALTER TABLE [dbo].[assay] CHECK CONSTRAINT [assay_marker_FK]
GO
ALTER TABLE [dbo].[denorm_genotype]  WITH CHECK ADD  CONSTRAINT [denorm_genotype_assay_FK] FOREIGN KEY([assay_id])
REFERENCES [dbo].[assay] ([assay_id])
GO
ALTER TABLE [dbo].[denorm_genotype] CHECK CONSTRAINT [denorm_genotype_assay_FK]
GO
ALTER TABLE [dbo].[denorm_genotype]  WITH CHECK ADD  CONSTRAINT [denorm_genotype_individual_FK] FOREIGN KEY([individual_id])
REFERENCES [dbo].[individual] ([individual_id])
GO
ALTER TABLE [dbo].[denorm_genotype] CHECK CONSTRAINT [denorm_genotype_individual_FK]
GO
ALTER TABLE [dbo].[denorm_genotype]  WITH CHECK ADD  CONSTRAINT [denorm_genotype_marker_FK] FOREIGN KEY([marker_id])
REFERENCES [dbo].[marker] ([marker_id])
GO
ALTER TABLE [dbo].[denorm_genotype] CHECK CONSTRAINT [denorm_genotype_marker_FK]
GO
ALTER TABLE [dbo].[denorm_genotype]  WITH CHECK ADD  CONSTRAINT [denorm_genotype_plate_FK] FOREIGN KEY([plate_id])
REFERENCES [dbo].[plate] ([plate_id])
GO
ALTER TABLE [dbo].[denorm_genotype] CHECK CONSTRAINT [denorm_genotype_plate_FK]
GO
ALTER TABLE [dbo].[denorm_genotype]  WITH CHECK ADD  CONSTRAINT [denorm_genotype_sample_FK] FOREIGN KEY([sample_id])
REFERENCES [dbo].[sample] ([sample_id])
GO
ALTER TABLE [dbo].[denorm_genotype] CHECK CONSTRAINT [denorm_genotype_sample_FK]
GO
ALTER TABLE [dbo].[denorm_genotype]  WITH CHECK ADD  CONSTRAINT [denorm_genotype_status_FK] FOREIGN KEY([status_id])
REFERENCES [dbo].[status] ([status_id])
GO
ALTER TABLE [dbo].[denorm_genotype] CHECK CONSTRAINT [denorm_genotype_status_FK]
GO
ALTER TABLE [dbo].[individual]  WITH CHECK ADD  CONSTRAINT [individual_father_id_FK] FOREIGN KEY([father_id])
REFERENCES [dbo].[individual] ([individual_id])
GO
ALTER TABLE [dbo].[individual] CHECK CONSTRAINT [individual_father_id_FK]
GO
ALTER TABLE [dbo].[individual]  WITH CHECK ADD  CONSTRAINT [individual_individual_type_id_FK] FOREIGN KEY([individual_type_id])
REFERENCES [dbo].[individual_type] ([individual_type_id])
GO
ALTER TABLE [dbo].[individual] CHECK CONSTRAINT [individual_individual_type_id_FK]
GO
ALTER TABLE [dbo].[individual]  WITH CHECK ADD  CONSTRAINT [individual_mother_id_FK] FOREIGN KEY([mother_id])
REFERENCES [dbo].[individual] ([individual_id])
GO
ALTER TABLE [dbo].[individual] CHECK CONSTRAINT [individual_mother_id_FK]
GO
ALTER TABLE [dbo].[individual]  WITH CHECK ADD  CONSTRAINT [individual_sex_FK] FOREIGN KEY([sex_id])
REFERENCES [dbo].[sex] ([sex_id])
GO
ALTER TABLE [dbo].[individual] CHECK CONSTRAINT [individual_sex_FK]
GO
ALTER TABLE [dbo].[plate]  WITH CHECK ADD  CONSTRAINT [plate_authority_FK] FOREIGN KEY([authority_id])
REFERENCES [dbo].[authority] ([authority_id])
GO
ALTER TABLE [dbo].[plate] CHECK CONSTRAINT [plate_authority_FK]
GO
ALTER TABLE [dbo].[plate]  WITH CHECK ADD  CONSTRAINT [plate_project_FK] FOREIGN KEY([project_id])
REFERENCES [dbo].[project] ([project_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[plate] CHECK CONSTRAINT [plate_project_FK]
GO
ALTER TABLE [dbo].[reference_genotype]  WITH CHECK ADD  CONSTRAINT [reference_genotype_reference_set_FK] FOREIGN KEY([reference_set_id])
REFERENCES [dbo].[reference_set] ([reference_set_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[reference_genotype] CHECK CONSTRAINT [reference_genotype_reference_set_FK]
GO
ALTER TABLE [dbo].[sample]  WITH CHECK ADD  CONSTRAINT [sample_individual_FK] FOREIGN KEY([individual_id])
REFERENCES [dbo].[individual] ([individual_id])
GO
ALTER TABLE [dbo].[sample] CHECK CONSTRAINT [sample_individual_FK]
GO
ALTER TABLE [dbo].[status_log]  WITH CHECK ADD  CONSTRAINT [status_log_authority_FK] FOREIGN KEY([authority_id])
REFERENCES [dbo].[authority] ([authority_id])
GO
ALTER TABLE [dbo].[status_log] CHECK CONSTRAINT [status_log_authority_FK]
GO
ALTER TABLE [dbo].[status_log]  WITH CHECK ADD  CONSTRAINT [status_log_denorm_genotype_FK] FOREIGN KEY([genotype_id])
REFERENCES [dbo].[denorm_genotype] ([genotype_id])
GO
ALTER TABLE [dbo].[status_log] CHECK CONSTRAINT [status_log_denorm_genotype_FK]
GO
ALTER TABLE [dbo].[status_log]  WITH CHECK ADD  CONSTRAINT [status_log_new_status_FK] FOREIGN KEY([new_status_id])
REFERENCES [dbo].[status] ([status_id])
GO
ALTER TABLE [dbo].[status_log] CHECK CONSTRAINT [status_log_new_status_FK]
GO
ALTER TABLE [dbo].[status_log]  WITH CHECK ADD  CONSTRAINT [status_log_old_status_FK] FOREIGN KEY([old_status_id])
REFERENCES [dbo].[status] ([status_id])
GO
ALTER TABLE [dbo].[status_log] CHECK CONSTRAINT [status_log_old_status_FK]
GO
ALTER TABLE [dbo].[wset]  WITH CHECK ADD  CONSTRAINT [wset_authority_FK] FOREIGN KEY([authority_id])
REFERENCES [dbo].[authority] ([authority_id])
GO
ALTER TABLE [dbo].[wset] CHECK CONSTRAINT [wset_authority_FK]
GO
ALTER TABLE [dbo].[wset]  WITH CHECK ADD  CONSTRAINT [wset_project_FK] FOREIGN KEY([project_id])
REFERENCES [dbo].[project] ([project_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[wset] CHECK CONSTRAINT [wset_project_FK]
GO
ALTER TABLE [dbo].[wset]  WITH CHECK ADD  CONSTRAINT [wset_wset_type_FK] FOREIGN KEY([wset_type_id])
REFERENCES [dbo].[wset_type] ([wset_type_id])
GO
ALTER TABLE [dbo].[wset] CHECK CONSTRAINT [wset_wset_type_FK]
GO
ALTER TABLE [dbo].[wset_member]  WITH CHECK ADD  CONSTRAINT [wset_member_kind_FK] FOREIGN KEY([kind_id])
REFERENCES [dbo].[kind] ([kind_id])
GO
ALTER TABLE [dbo].[wset_member] CHECK CONSTRAINT [wset_member_kind_FK]
GO
ALTER TABLE [dbo].[wset_member]  WITH CHECK ADD  CONSTRAINT [wset_member_wset_FK] FOREIGN KEY([wset_id])
REFERENCES [dbo].[wset] ([wset_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[wset_member] CHECK CONSTRAINT [wset_member_wset_FK]
