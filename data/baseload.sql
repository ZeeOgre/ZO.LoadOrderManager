--
-- File generated with SQLiteStudio v3.4.4 on Tue Oct 29 20:00:17 2024
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Config
DROP TABLE IF EXISTS Config;

CREATE TABLE IF NOT EXISTS Config (
    GameFolder           TEXT    NOT NULL,
    AutoCheckForUpdates  INTEGER DEFAULT (1),
    DarkMode             INTEGER DEFAULT (1),
    ModManagerRepoFolder TEXT,
    ModManagerExecutable TEXT,
    ModManagerArguments  TEXT
);


-- Table: ExternalIDs
DROP TABLE IF EXISTS ExternalIDs;

CREATE TABLE IF NOT EXISTS ExternalIDs (
    ExternalID INTEGER PRIMARY KEY AUTOINCREMENT
                       NOT NULL,
    PluginID   INTEGER UNIQUE
                       REFERENCES Plugins (PluginID) ON DELETE CASCADE,
    BethesdaID TEXT,
    NexusID    TEXT,
    CONSTRAINT FK_ExternalIDs_PluginID FOREIGN KEY (
        PluginID
    )
    REFERENCES Plugins (PluginID) ON DELETE NO ACTION
                                  ON UPDATE NO ACTION
);

INSERT INTO ExternalIDs (ExternalID, PluginID, BethesdaID, NexusID) VALUES (1, 11, NULL, '10189');
INSERT INTO ExternalIDs (ExternalID, PluginID, BethesdaID, NexusID) VALUES (2, 10, 'b6b52ca2-3f1f-4316-bef8-dcb0bb2dcc32', NULL);

-- Table: FileInfo
DROP TABLE IF EXISTS FileInfo;

CREATE TABLE IF NOT EXISTS FileInfo (
    FileID               INTEGER PRIMARY KEY AUTOINCREMENT
                                 NOT NULL,
    PluginID             INTEGER REFERENCES Plugins (PluginID) ON DELETE CASCADE,
    Filename             TEXT    NOT NULL
                                 UNIQUE,
    RelativePath         TEXT,
    AbsolutePath         TEXT,
    ModManagerFolderPath TEXT,
    DTStamp              TEXT    NOT NULL,
    HASH                 TEXT,
    Flags                INTEGER,
    FileContent          BLOB,
    CONSTRAINT FK_FileInfo_PluginID FOREIGN KEY (
        PluginID
    )
    REFERENCES Plugins (PluginID) ON DELETE NO ACTION
                                  ON UPDATE NO ACTION
);

INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (1, NULL, 'Plugins.txt', '', '', NULL, '2024-10-01 09:59:10', '', 3, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (2, NULL, 'ContentCatalog.txt', '', '', NULL, '2024-10-01 09:59:10', '', 3, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (3, NULL, 'Starfield.ccc', '', '', NULL, '2024-10-01 09:59:10', '', 4, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (4, NULL, 'Starfield.ini', '', '', NULL, '2024-10-01 09:59:10', '', 4, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (5, NULL, 'StarfieldCustom.ini', '', '', NULL, '2024-10-01 09:59:10', '', 4, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (6, NULL, 'StarfieldPrefs.ini', '', '', NULL, '2024-10-01 09:59:10', '', 4, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (7, 1, 'blueprintships-starfield.esm', NULL, NULL, NULL, '2024-09-30 10:09:15', '03c42931e5dc2e61', 24, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (8, 1, 'BlueprintShips-Starfield - Localization.ba2', NULL, NULL, NULL, '2024-09-30 10:09:50', '6c20274d28bc606d', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (9, 2, 'constellation.esm', NULL, NULL, NULL, '2023-08-31 14:54:50', '1029431ecafd66b4', 16, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (10, 2, 'Constellation - Localization.ba2', NULL, NULL, NULL, '2023-08-31 14:54:50', '367ea3137ff46168', 128, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (11, 2, 'Constellation - Textures.ba2', NULL, NULL, NULL, '2023-08-31 14:54:50', '59511774a95b60fb', 128, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (12, 3, 'oldmars.esm', NULL, NULL, NULL, '2023-08-31 14:54:50', '89ddfadc7715621e', 16, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (13, 3, 'OldMars - Localization.ba2', NULL, NULL, NULL, '2023-08-31 14:54:50', '6d44c4a3a0be22d3', 128, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (14, 3, 'OldMars - Textures.ba2', NULL, NULL, NULL, '2023-08-31 14:54:50', '5bc0fa32b4138b44', 128, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (15, 4, 'sfbgs003.esm', NULL, NULL, NULL, '2024-09-30 10:15:14', '19d906fcf0f46fe0', 24, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (16, 4, 'SFBGS003 - Main.ba2', NULL, NULL, NULL, '2024-09-30 10:15:23', 'c3f8a8ba98e6c4bb', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (17, 4, 'SFBGS003 - Textures.ba2', NULL, NULL, NULL, '2024-09-30 10:15:24', '04db1a8c940decfb', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (18, 4, 'SFBGS003 - Voices_de.ba2', NULL, NULL, NULL, '2024-09-30 10:15:25', 'bf1b08c19ff3598d', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (19, 4, 'SFBGS003 - Voices_en.ba2', NULL, NULL, NULL, '2024-09-30 10:15:26', 'fa03097ef5814d13', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (20, 4, 'SFBGS003 - Voices_es.ba2', NULL, NULL, NULL, '2024-09-30 10:15:27', '548929e1d9be2a15', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (21, 4, 'SFBGS003 - Voices_fr.ba2', NULL, NULL, NULL, '2024-09-30 10:15:27', '3e78e3ff3cd00cc3', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (22, 4, 'SFBGS003 - Voices_ja.ba2', NULL, NULL, NULL, '2024-09-30 10:15:27', 'df137bfe3c313c41', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (23, 5, 'sfbgs004.esm', NULL, NULL, NULL, '2024-09-30 10:15:14', 'af818d64b3f03932', 24, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (24, 5, 'SFBGS004 - Main.ba2', NULL, NULL, NULL, '2024-09-30 10:15:28', '423813ab3ee5389c', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (25, 5, 'SFBGS004 - Textures.ba2', NULL, NULL, NULL, '2024-09-30 10:15:28', '8f9780cf8c593d0e', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (26, 5, 'SFBGS004 - Voices_de.ba2', NULL, NULL, NULL, '2024-08-20 19:17:13', '0f8b997c25012d00', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (27, 5, 'SFBGS004 - Voices_en.ba2', NULL, NULL, NULL, '2024-08-20 19:17:13', 'd7584adf64bfd382', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (28, 5, 'SFBGS004 - Voices_es.ba2', NULL, NULL, NULL, '2024-08-20 19:17:13', '081415d7d0e22759', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (29, 5, 'SFBGS004 - Voices_fr.ba2', NULL, NULL, NULL, '2024-08-20 19:17:13', '9dcf00774d1fc43c', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (30, 5, 'SFBGS004 - Voices_ja.ba2', NULL, NULL, NULL, '2024-08-20 19:17:14', 'f69baf3861e605e3', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (31, 6, 'sfbgs006.esm', NULL, NULL, NULL, '2024-06-09 23:09:33', 'e4c13903cd5f2fc5', 24, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (32, 6, 'SFBGS006 - Main.ba2', NULL, NULL, NULL, '2024-06-09 23:10:06', 'd166126555f5f017', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (33, 6, 'SFBGS006 - Textures.ba2', NULL, NULL, NULL, '2024-06-09 23:10:06', '91fac923e08d7818', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (34, 7, 'sfbgs007.esm', NULL, NULL, NULL, '2024-08-20 19:16:59', '1967feec0a495e0e', 24, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (35, 7, 'SFBGS007 - Main.ba2', NULL, NULL, NULL, '2024-08-20 19:17:16', '99552debe766b922', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (36, 8, 'sfbgs008.esm', NULL, NULL, NULL, '2024-09-30 10:15:14', '925cfe08877b693c', 24, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (37, 8, 'SFBGS008 - Main.ba2', NULL, NULL, NULL, '2024-09-30 10:15:28', 'f60d40ea49582a1b', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (38, 9, 'starfield.esm', NULL, NULL, NULL, '2024-09-30 10:09:10', '2b593f094c9dcbca', 24, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (39, 9, 'Starfield - Animations.ba2', NULL, NULL, NULL, '2024-09-30 10:09:18', '966243e0cce552eb', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (40, 9, 'Starfield - DensityMaps.ba2', NULL, NULL, NULL, '2024-06-09 23:06:37', '11c37332e2c9c0d6', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (41, 9, 'Starfield - FaceAnimation01.ba2', NULL, NULL, NULL, '2024-06-09 22:35:41', '7c4c6034156760c2', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (42, 9, 'Starfield - FaceAnimation02.ba2', NULL, NULL, NULL, '2024-06-09 22:36:49', '79de37443fd5432d', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (43, 9, 'Starfield - FaceAnimation03.ba2', NULL, NULL, NULL, '2024-06-09 22:38:09', 'c4ace1cdb49bbd23', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (44, 9, 'Starfield - FaceAnimation04.ba2', NULL, NULL, NULL, '2024-06-09 22:39:06', '4ed4e79cab17579b', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (45, 9, 'Starfield - FaceAnimationPatch.ba2', NULL, NULL, NULL, '2024-09-30 10:09:44', '326df6609c12ae8e', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (46, 9, 'Starfield - FaceMeshes.ba2', NULL, NULL, NULL, '2024-09-30 10:10:42', '995bd670c2197faa', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (47, 9, 'Starfield - GeneratedTextures.ba2', NULL, NULL, NULL, '2024-09-30 10:10:46', '0c7b52ad36b71099', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (48, 9, 'Starfield - Interface.ba2', NULL, NULL, NULL, '2024-09-30 10:09:46', 'baf46a98140deedc', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (49, 9, 'Starfield - Localization.ba2', NULL, NULL, NULL, '2024-09-30 10:09:50', 'd63be14958ce4cd9', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (50, 9, 'Starfield - LODMeshes.ba2', NULL, NULL, NULL, '2024-06-09 22:41:43', 'd36b3f45fca5b600', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (51, 9, 'Starfield - LODMeshesPatch.ba2', NULL, NULL, NULL, '2024-09-30 10:10:42', '026a114bb63fc4e3', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (52, 9, 'Starfield - LODTextures01.ba2', NULL, NULL, NULL, '2024-09-30 10:13:04', '744d6f88ab7e4bda', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (53, 9, 'Starfield - LODTextures02.ba2', NULL, NULL, NULL, '2024-09-30 10:13:06', '07124aa7139513fe', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (54, 9, 'Starfield - Materials.ba2', NULL, NULL, NULL, '2024-09-30 10:09:52', 'e26ccefe4d3a430c', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (55, 9, 'Starfield - Meshes01.ba2', NULL, NULL, NULL, '2024-06-09 22:41:02', 'e29c5372b70b46b1', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (56, 9, 'Starfield - Meshes02.ba2', NULL, NULL, NULL, '2024-06-09 22:41:26', '6bc1ea60d2125f3b', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (57, 9, 'Starfield - MeshesPatch.ba2', NULL, NULL, NULL, '2024-09-30 10:14:24', '97c507078e98a818', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (58, 9, 'Starfield - Misc.ba2', NULL, NULL, NULL, '2024-09-30 10:10:42', '474b9a1fae9cae30', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (59, 9, 'Starfield - Particles.ba2', NULL, NULL, NULL, '2024-09-30 10:10:44', '0f471ebb3ad6c0d7', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (60, 9, 'Starfield - PlanetData.ba2', NULL, NULL, NULL, '2024-06-09 22:41:46', '701d62278e8d8c12', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (61, 9, 'Starfield - Shaders.ba2', NULL, NULL, NULL, '2024-09-30 10:10:46', '9564647c4d12c0d1', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (62, 9, 'Starfield - Terrain01.ba2', NULL, NULL, NULL, '2024-06-09 22:43:03', '9823bc906e46d6df', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (63, 9, 'Starfield - Terrain02.ba2', NULL, NULL, NULL, '2024-06-09 22:44:24', '6bd4240337c60783', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (64, 9, 'Starfield - Terrain03.ba2', NULL, NULL, NULL, '2024-06-09 22:45:24', 'a00d6eed47188e27', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (65, 9, 'Starfield - Terrain04.ba2', NULL, NULL, NULL, '2024-06-09 22:46:06', '5fc8aaf090c36f23', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (66, 9, 'Starfield - TerrainPatch.ba2', NULL, NULL, NULL, '2024-06-09 22:46:06', '9bb1965c69ce7a06', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (67, 9, 'Starfield - Textures01.ba2', NULL, NULL, NULL, '2024-06-09 22:47:32', 'd7240460024dfa27', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (68, 9, 'Starfield - Textures02.ba2', NULL, NULL, NULL, '2024-06-09 22:48:32', '4c46e37635e7fba1', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (69, 9, 'Starfield - Textures03.ba2', NULL, NULL, NULL, '2024-06-09 22:49:30', '8718f56e74b21a3d', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (70, 9, 'Starfield - Textures04.ba2', NULL, NULL, NULL, '2024-06-09 22:50:51', 'ac1865a8046cccd9', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (71, 9, 'Starfield - Textures05.ba2', NULL, NULL, NULL, '2024-06-09 22:52:14', '322634377e9117aa', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (72, 9, 'Starfield - Textures06.ba2', NULL, NULL, NULL, '2024-06-09 22:53:39', '00b3ffb2cb8c08c2', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (73, 9, 'Starfield - Textures07.ba2', NULL, NULL, NULL, '2024-06-09 22:55:09', '757d38ae36a93525', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (74, 9, 'Starfield - Textures08.ba2', NULL, NULL, NULL, '2024-06-09 22:56:40', '8df85ea8f4fa3a29', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (75, 9, 'Starfield - Textures09.ba2', NULL, NULL, NULL, '2024-06-09 22:58:09', '9a37829b2bf7dbcc', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (76, 9, 'Starfield - Textures10.ba2', NULL, NULL, NULL, '2024-06-09 22:59:39', 'fd885ceebb3bd777', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (77, 9, 'Starfield - Textures11.ba2', NULL, NULL, NULL, '2024-06-09 22:59:57', '7f0737a52c619e58', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (78, 9, 'Starfield - TexturesPatch.ba2', NULL, NULL, NULL, '2024-09-30 10:15:13', '3b02e94b9e4cc6dd', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (79, 9, 'Starfield - Voices01.ba2', NULL, NULL, NULL, '2024-06-09 23:04:21', 'f42d6d9778e9594c', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (80, 9, 'Starfield - Voices02.ba2', NULL, NULL, NULL, '2024-06-09 23:05:13', '71d8d0ad7ade49e5', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (81, 9, 'Starfield - VoicesPatch.ba2', NULL, NULL, NULL, '2024-09-30 10:13:07', 'b7fbbe2d365bbdbc', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (82, 9, 'Starfield - WwiseSounds01.ba2', NULL, NULL, NULL, '2024-09-30 10:13:06', '7e397d63eebcbc92', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (83, 9, 'Starfield - WwiseSounds02.ba2', NULL, NULL, NULL, '2023-10-03 10:59:05', '8248b4d8ea4c0d11', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (84, 9, 'Starfield - WwiseSounds03.ba2', NULL, NULL, NULL, '2024-06-09 22:33:44', 'f1bbdcc1dda7b835', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (85, 9, 'Starfield - WwiseSounds04.ba2', NULL, NULL, NULL, '2023-10-03 11:00:29', 'e2c2b062fe13be25', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (86, 9, 'Starfield - WwiseSounds05.ba2', NULL, NULL, NULL, '2023-10-03 11:00:58', 'a6093fd4dc6f5600', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (87, 9, 'Starfield - WwiseSoundsPatch.ba2', NULL, NULL, NULL, '2024-09-30 10:13:26', 'f96a1673ae46e20c', 136, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (88, 10, 'shatteredspace.esm', NULL, NULL, NULL, '2024-09-30 10:17:57', '00f59ae51f4afacc', 8, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (89, 10, 'ShatteredSpace - Main01.ba2', NULL, NULL, NULL, '2024-09-30 10:18:40', '3a29063df1f52c7e', 128, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (90, 10, 'ShatteredSpace - Main02.ba2', NULL, NULL, NULL, '2024-09-30 10:18:54', '6d2c2d101dc04fe5', 128, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (91, 10, 'ShatteredSpace - Textures.ba2', NULL, NULL, NULL, '2024-09-30 10:19:13', 'b170b252b0e954cb', 128, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (92, 10, 'ShatteredSpace - Voices_en.ba2', NULL, NULL, NULL, '2024-09-30 10:19:23', 'd29b82d2b07acff0', 128, NULL);
INSERT INTO FileInfo (FileID, PluginID, Filename, RelativePath, AbsolutePath, ModManagerFolderPath, DTStamp, HASH, Flags, FileContent) VALUES (93, 11, 'a1_empty_stub_xxxxxxxxxx.esm', NULL, NULL, NULL, '2024-06-26 19:53:36', 'e0af782232dd253d', 8, NULL);

-- Table: GroupSetGroups
DROP TABLE IF EXISTS GroupSetGroups;

CREATE TABLE IF NOT EXISTS GroupSetGroups (
    GroupID    INTEGER NOT NULL
                       REFERENCES ModGroups (GroupID) ON DELETE CASCADE,
    GroupSetID INTEGER NOT NULL
                       REFERENCES GroupSets (GroupSetID) ON DELETE CASCADE,
    ParentID   INTEGER REFERENCES GroupSets (GroupSetID) ON DELETE RESTRICT,
    Ordinal    INTEGER,
    FOREIGN KEY (
        GroupID
    )
    REFERENCES ModGroups (GroupID),
    UNIQUE (
        GroupID,
        GroupSetID
    )
    ON CONFLICT REPLACE,
    PRIMARY KEY (
        GroupID ASC,
        GroupSetID ASC
    )
);

INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (-999, 1, 1, 9999);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (-998, 1, 1, 9998);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (-997, 1, 1, 9997);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (1, 1, 0, 0);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (1, 2, 0, 0);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (-997, 2, 1, 9997);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (1, 3, 0, 0);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (-997, 3, 1, 9997);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (2, 3, 1, 1);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (3, 3, 1, 2);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (4, 3, 1, 3);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (5, 3, 1, 4);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (6, 3, 5, 1);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (7, 3, 5, 2);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (8, 3, 5, 3);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (9, 3, 1, 5);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (10, 3, 1, 6);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (11, 3, 10, 1);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (12, 3, 10, 2);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (13, 3, 1, 7);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (14, 3, 1, 8);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (15, 3, 1, 9);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (16, 3, 1, 10);
INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal) VALUES (17, 3, 5, 4);

-- Table: GroupSetPlugins
DROP TABLE IF EXISTS GroupSetPlugins;

CREATE TABLE IF NOT EXISTS GroupSetPlugins (
    GroupSetID INTEGER NOT NULL
                       REFERENCES GroupSets (GroupSetID) ON DELETE CASCADE,
    GroupID    INTEGER NOT NULL
                       REFERENCES ModGroups (GroupID) ON DELETE SET DEFAULT
                       DEFAULT ( -997),
    PluginID   INTEGER NOT NULL
                       REFERENCES Plugins (PluginID) ON DELETE CASCADE,
    Ordinal    INTEGER NOT NULL,
    CONSTRAINT PK_GroupSetPlugins PRIMARY KEY (
        GroupSetID,
        PluginID
    ),
    CONSTRAINT FK_GroupSetPlugins_GroupSetID FOREIGN KEY (
        GroupSetID
    )
    REFERENCES GroupSets (GroupSetID) ON DELETE NO ACTION
                                      ON UPDATE NO ACTION,
    CONSTRAINT FK_GroupSetPlugins_GroupID FOREIGN KEY (
        GroupID
    )
    REFERENCES ModGroups (GroupID) ON DELETE NO ACTION
                                   ON UPDATE NO ACTION,
    CONSTRAINT FK_GroupSetPlugins_PluginID FOREIGN KEY (
        PluginID
    )
    REFERENCES Plugins (PluginID) ON DELETE NO ACTION
                                  ON UPDATE NO ACTION,
    UNIQUE (
        GroupSetID,
        PluginID
    )
    ON CONFLICT REPLACE
);

INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -999, 1, 1);
INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -999, 2, 2);
INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -999, 3, 3);
INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -999, 4, 4);
INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -999, 5, 5);
INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -999, 6, 6);
INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -999, 7, 7);
INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -999, 8, 8);
INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -999, 9, 9);
INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -999, 10, 10);
INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal) VALUES (1, -998, 11, 1);

-- Table: GroupSets
DROP TABLE IF EXISTS GroupSets;

CREATE TABLE IF NOT EXISTS GroupSets (
    GroupSetID    INTEGER    PRIMARY KEY AUTOINCREMENT,
    GroupSetName  TEXT,
    GroupSetFlags INTEGER,
    IsFavorite    [INTEGER ] GENERATED ALWAYS AS (GroupSetFlags & 4) VIRTUAL
);

INSERT INTO GroupSets (GroupSetID, GroupSetName, GroupSetFlags) VALUES (1, 'BASELINE', 9);
INSERT INTO GroupSets (GroupSetID, GroupSetName, GroupSetFlags) VALUES (2, '(Default)', 8);
INSERT INTO GroupSets (GroupSetID, GroupSetName, GroupSetFlags) VALUES (3, 'ZeeOgre''s Sample', 12);

-- Table: InitializationStatus
DROP TABLE IF EXISTS InitializationStatus;

CREATE TABLE IF NOT EXISTS InitializationStatus (
    Id                 INTEGER PRIMARY KEY AUTOINCREMENT
                               NOT NULL,
    IsInitialized      INTEGER NOT NULL,
    InitializationTime TEXT    NOT NULL
);


-- Table: LoadOutProfiles
DROP TABLE IF EXISTS LoadOutProfiles;

CREATE TABLE IF NOT EXISTS LoadOutProfiles (
    ProfileID   INTEGER PRIMARY KEY AUTOINCREMENT
                        NOT NULL,
    ProfileName TEXT    NOT NULL,
    GroupSetID  INTEGER REFERENCES GroupSets (GroupSetID) ON DELETE CASCADE,
    isFavorite  INTEGER DEFAULT (0) 
);

INSERT INTO LoadOutProfiles (ProfileID, ProfileName, GroupSetID, isFavorite) VALUES (1, 'Baseline', 1, 1);
INSERT INTO LoadOutProfiles (ProfileID, ProfileName, GroupSetID, isFavorite) VALUES (2, '(Default)', 2, 1);
INSERT INTO LoadOutProfiles (ProfileID, ProfileName, GroupSetID, isFavorite) VALUES (3, 'ZeeOgre''s Default', 3, 1);
INSERT INTO LoadOutProfiles (ProfileID, ProfileName, GroupSetID, isFavorite) VALUES (4, 'ZeeOgre''s NG+ Speedrun ', 3, 0);
INSERT INTO LoadOutProfiles (ProfileID, ProfileName, GroupSetID, isFavorite) VALUES (5, 'ZeeOgre''s Completionist', 3, 0);
INSERT INTO LoadOutProfiles (ProfileID, ProfileName, GroupSetID, isFavorite) VALUES (6, 'ZeeOgre''s Shattered Space', 3, 0);
INSERT INTO LoadOutProfiles (ProfileID, ProfileName, GroupSetID, isFavorite) VALUES (7, 'ZeeOgre''s Minimal Development', 3, 0);

-- Table: ModGroups
DROP TABLE IF EXISTS ModGroups;

CREATE TABLE IF NOT EXISTS ModGroups (
    GroupID     INTEGER PRIMARY KEY AUTOINCREMENT,
    GroupName   TEXT    NOT NULL,
    Description TEXT
);

INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (-999, 'CoreGameFiles', 'This is a reserved group for mods that are an integral part of the game and can''t be controlled by the player');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (-998, 'NeverLoad', 'This is a reserved group for mods which should never be loaded');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (-997, 'Uncategorized', 'This is a reserved group to temporarily hold uncategorized mods');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (1, '(Default Root)', 'This is the Default Root group which holds all the other groups');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (2, 'BethesdaPaid', 'Bethesda paid mods');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (3, 'Community Patch', 'https://starfieldpatch.dev');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (4, 'Places', 'New and furnished locations');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (5, 'New Things', 'Objects, Followers, etc..');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (6, 'Followers', 'People, critters and bots that will follow you around');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (7, 'Items', 'Added Clothing, Armor, Items');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (8, 'New Ships', 'Ships');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (9, 'Gameplay Modification', 'Mods which change game behavior, but you might want to still override some of the things that happen here.');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (10, 'High Priority Mods', 'mods which should never be changed except by deliberate choice');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (11, 'DarkStar', 'Darkstar by Wykkyd Gaming');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (12, 'Shipbuilding', 'Habs, ship related mods, etc');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (13, 'High Priority Overrides', 'These mods are known to make changes that may override other mods, and should be loaded after everything else.');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (14, 'ForcedOverrides', 'Deliberate override choices which you never want to be overriden by anything else');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (15, 'ESP', 'ESP files - these are generally "in development" mods, and should always be loaded last.');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (16, 'In Development', 'Specific Non-development mods. Generally best to be loaded very late to make sure there are no conflicts.');
INSERT INTO ModGroups (GroupID, GroupName, Description) VALUES (17, 'Vehicles', 'The REV-8 Buggy and it''s related changes');

-- Table: Plugins
DROP TABLE IF EXISTS Plugins;

CREATE TABLE IF NOT EXISTS Plugins (
    PluginID     INTEGER PRIMARY KEY AUTOINCREMENT
                         NOT NULL,
    PluginName   TEXT    NOT NULL,
    Description  TEXT,
    Achievements INTEGER DEFAULT (0),
    DTStamp      TEXT    DEFAULT (CURRENT_TIMESTAMP),
    Version      TEXT,
    State        INTEGER
);

INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (1, 'blueprintships-starfield.esm', 'Core game file containing all the ship models (We think!)', 1, '2024-08-20 18:18:57', NULL, 1);
INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (2, 'constellation.esm', 'Premium Edition Content', 1, '2024-06-28 00:43:13', NULL, 1);
INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (3, 'oldmars.esm', 'Premium Edition - Old Mars Skins', 1, '2024-09-19', NULL, 1);
INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (4, 'sfbgs003.esm', 'Tracker''s Alliance update', 1, '2024-08-20 18:18:57', NULL, 1);
INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (5, 'sfbgs004.esm', 'REV-8 Vehicle', 1, '2024-08-20 18:19:01', NULL, 1);
INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (6, 'sfbgs006.esm', 'Empty Ship Habs and Decorations', 1, '2024-06-28 00:22:40', NULL, 1);
INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (7, 'sfbgs007.esm', 'Add "GamePlay Options" Menu', 1, '2024-08-20 18:19:16', NULL, 1);
INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (8, 'sfbgs008.esm', 'New Map design (3d maps)', 1, '2024-08-20 18:18:57', NULL, 1);
INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (9, 'starfield.esm', 'The core Starfield game', 1, '2024-08-20 18:18:57', NULL, 1);
INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (10, 'shatteredspace.esm', 'Shattered Space Expansion', 1, '2024-09-30 10:00', NULL, 1);
INSERT INTO Plugins (PluginID, PluginName, Description, Achievements, DTStamp, Version, State) VALUES (11, 'A1_EMPTY_STUB_XXXXXXXXXX.esm', 'JMPz11''s stub for converting mods between xEdit and Creation Kit, WILL crash your game if you try to load it.', 0, '2024-06-24 19:53:00', NULL, 4);

-- Table: ProfilePlugins
DROP TABLE IF EXISTS ProfilePlugins;

CREATE TABLE IF NOT EXISTS ProfilePlugins (
    ProfileID INTEGER NOT NULL
                      REFERENCES LoadOutProfiles (ProfileID) ON DELETE CASCADE,
    PluginID  INTEGER NOT NULL
                      REFERENCES Plugins (PluginID) ON DELETE CASCADE,
    CONSTRAINT PK_ProfilePlugins PRIMARY KEY (
        ProfileID,
        PluginID
    ),
    CONSTRAINT FK_ProfilePlugins_PluginID FOREIGN KEY (
        PluginID
    )
    REFERENCES Plugins (PluginID) ON DELETE CASCADE
                                  ON UPDATE NO ACTION,
    CONSTRAINT FK_ProfilePlugins_ProfileID FOREIGN KEY (
        ProfileID
    )
    REFERENCES LoadOutProfiles (ProfileID) ON DELETE CASCADE
                                           ON UPDATE NO ACTION,
    UNIQUE (
        ProfileID,
        PluginID
    )
);

INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (1, 1);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (2, 1);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (1, 2);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (2, 2);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (1, 3);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (2, 3);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (1, 4);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (2, 4);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (1, 5);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (2, 5);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (1, 6);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (2, 6);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (1, 7);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (2, 7);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (1, 8);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (2, 8);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (1, 9);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (2, 9);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (3, 10);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (1, 10);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (2, 10);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (3, 1);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (3, 2);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (3, 3);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (3, 4);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (3, 5);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (3, 6);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (3, 7);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (3, 8);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (3, 9);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (4, 1);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (4, 2);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (4, 3);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (4, 4);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (4, 5);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (4, 6);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (4, 7);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (4, 8);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (4, 9);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (4, 10);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (5, 1);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (5, 2);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (5, 3);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (5, 4);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (5, 5);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (5, 6);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (5, 7);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (5, 8);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (5, 9);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (5, 10);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (6, 1);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (6, 2);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (6, 3);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (6, 4);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (6, 5);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (6, 6);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (6, 7);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (6, 8);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (6, 9);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (6, 10);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (7, 1);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (7, 2);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (7, 3);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (7, 4);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (7, 5);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (7, 6);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (7, 7);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (7, 8);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (7, 9);
INSERT INTO ProfilePlugins (ProfileID, PluginID) VALUES (7, 10);

-- Index: Plugins_Plugins_idx_Plugins_PluginName
DROP INDEX IF EXISTS Plugins_Plugins_idx_Plugins_PluginName;

CREATE UNIQUE INDEX IF NOT EXISTS Plugins_Plugins_idx_Plugins_PluginName ON Plugins (
    PluginName ASC
);


-- Trigger: enforce_ordinal_fk
DROP TRIGGER IF EXISTS enforce_ordinal_fk;
CREATE TRIGGER IF NOT EXISTS enforce_ordinal_fk
                      BEFORE INSERT
                          ON GroupSetGroups
                    FOR EACH ROW
                        WHEN NEW.GroupID != 1 AND 
                             (
                                 SELECT COUNT( * ) 
                                   FROM ModGroups
                                  WHERE GroupID = NEW.ParentID
                             )
=                            0
BEGIN
    SELECT RAISE(FAIL, "Foreign Key Violation: ParentID must exist in ModGroups table.");
END;


-- Trigger: enforce_unique_favorite_insert
DROP TRIGGER IF EXISTS enforce_unique_favorite_insert;
CREATE TRIGGER IF NOT EXISTS enforce_unique_favorite_insert
                      BEFORE INSERT
                          ON GroupSets
                    FOR EACH ROW
                        WHEN (NEW.GroupSetFlags & 4) != 0
BEGIN
    UPDATE GroupSets
       SET GroupSetFlags = GroupSetFlags & ~4
     WHERE (GroupSetFlags & 4) != 0;
END;


-- Trigger: enforce_unique_favorite_update
DROP TRIGGER IF EXISTS enforce_unique_favorite_update;
CREATE TRIGGER IF NOT EXISTS enforce_unique_favorite_update
                      BEFORE UPDATE
                          ON GroupSets
                    FOR EACH ROW
                        WHEN (NEW.GroupSetFlags & 4) != 0 AND 
                             (OLD.GroupSetFlags & 4) = 0
BEGIN-- Clear the Favorite flag on all other GroupSets
    UPDATE GroupSets
       SET GroupSetFlags = GroupSetFlags & ~4
     WHERE (GroupSetFlags & 4) != 0;-- Allow the update to proceed
END;


-- Trigger: EnsureSingleFavorite
DROP TRIGGER IF EXISTS EnsureSingleFavorite;
CREATE TRIGGER IF NOT EXISTS EnsureSingleFavorite
                      BEFORE INSERT
                          ON LoadOutProfiles
                    FOR EACH ROW
                        WHEN NEW.isFavorite = 1
BEGIN
    UPDATE LoadOutProfiles
       SET isFavorite = 0
     WHERE GroupSetID = NEW.GroupSetID AND 
           ProfileID != NEW.ProfileID;
END;


-- Trigger: EnsureSingleFavoriteUpdate
DROP TRIGGER IF EXISTS EnsureSingleFavoriteUpdate;
CREATE TRIGGER IF NOT EXISTS EnsureSingleFavoriteUpdate
                      BEFORE UPDATE OF isFavorite
                          ON LoadOutProfiles
                    FOR EACH ROW
                        WHEN NEW.isFavorite = 1
BEGIN
    UPDATE LoadOutProfiles
       SET isFavorite = 0
     WHERE GroupSetID = NEW.GroupSetID AND 
           ProfileID != NEW.ProfileID;
END;


-- Trigger: fki_ExternalIDs_PluginID_Plugins_PluginID
DROP TRIGGER IF EXISTS fki_ExternalIDs_PluginID_Plugins_PluginID;
CREATE TRIGGER IF NOT EXISTS fki_ExternalIDs_PluginID_Plugins_PluginID
                      BEFORE INSERT
                          ON ExternalIDs
                    FOR EACH ROW
BEGIN
    SELECT RAISE(ROLLBACK, "Insert on table ExternalIDs violates foreign key constraint FK_ExternalIDs_0_0") 
     WHERE NEW.PluginID IS NOT NULL AND 
           (
               SELECT PluginID
                 FROM Plugins
                WHERE PluginID = NEW.PluginID
           )
           IS NULL;
END;


-- Trigger: fki_FileInfo_PluginID_Plugins_PluginID
DROP TRIGGER IF EXISTS fki_FileInfo_PluginID_Plugins_PluginID;
CREATE TRIGGER IF NOT EXISTS fki_FileInfo_PluginID_Plugins_PluginID
                      BEFORE INSERT
                          ON FileInfo
                    FOR EACH ROW
BEGIN
    SELECT RAISE(ROLLBACK, "Insert on table FileInfo violates foreign key constraint FK_FileInfo_0_0") 
     WHERE NEW.PluginID IS NOT NULL AND 
           (
               SELECT PluginID
                 FROM Plugins
                WHERE PluginID = NEW.PluginID
           )
           IS NULL;
END;


-- Trigger: fki_ProfilePlugins_PluginID_Plugins_PluginID
DROP TRIGGER IF EXISTS fki_ProfilePlugins_PluginID_Plugins_PluginID;
CREATE TRIGGER IF NOT EXISTS fki_ProfilePlugins_PluginID_Plugins_PluginID
                      BEFORE INSERT
                          ON ProfilePlugins
                    FOR EACH ROW
BEGIN
    SELECT RAISE(ROLLBACK, "Insert on table ProfilePlugins violates foreign key constraint FK_ProfilePlugins_0_0") 
     WHERE (
               SELECT PluginID
                 FROM Plugins
                WHERE PluginID = NEW.PluginID
           )
           IS NULL;
END;


-- Trigger: fki_ProfilePlugins_ProfileID_LoadOutProfiles_ProfileID
DROP TRIGGER IF EXISTS fki_ProfilePlugins_ProfileID_LoadOutProfiles_ProfileID;
CREATE TRIGGER IF NOT EXISTS fki_ProfilePlugins_ProfileID_LoadOutProfiles_ProfileID
                      BEFORE INSERT
                          ON ProfilePlugins
                    FOR EACH ROW
BEGIN
    SELECT RAISE(ROLLBACK, "Insert on table ProfilePlugins violates foreign key constraint FK_ProfilePlugins_1_0") 
     WHERE (
               SELECT ProfileID
                 FROM LoadOutProfiles
                WHERE ProfileID = NEW.ProfileID
           )
           IS NULL;
END;


-- Trigger: fku_ExternalIDs_PluginID_Plugins_PluginID
DROP TRIGGER IF EXISTS fku_ExternalIDs_PluginID_Plugins_PluginID;
CREATE TRIGGER IF NOT EXISTS fku_ExternalIDs_PluginID_Plugins_PluginID
                      BEFORE UPDATE
                          ON ExternalIDs
                    FOR EACH ROW
BEGIN
    SELECT RAISE(ROLLBACK, "Update on table ExternalIDs violates foreign key constraint FK_ExternalIDs_0_0") 
     WHERE NEW.PluginID IS NOT NULL AND 
           (
               SELECT PluginID
                 FROM Plugins
                WHERE PluginID = NEW.PluginID
           )
           IS NULL;
END;


-- Trigger: fku_FileInfo_PluginID_Plugins_PluginID
DROP TRIGGER IF EXISTS fku_FileInfo_PluginID_Plugins_PluginID;
CREATE TRIGGER IF NOT EXISTS fku_FileInfo_PluginID_Plugins_PluginID
                      BEFORE UPDATE
                          ON FileInfo
                    FOR EACH ROW
BEGIN
    SELECT RAISE(ROLLBACK, "Update on table FileInfo violates foreign key constraint FK_FileInfo_0_0") 
     WHERE NEW.PluginID IS NOT NULL AND 
           (
               SELECT PluginID
                 FROM Plugins
                WHERE PluginID = NEW.PluginID
           )
           IS NULL;
END;


-- Trigger: fku_ProfilePlugins_PluginID_Plugins_PluginID
DROP TRIGGER IF EXISTS fku_ProfilePlugins_PluginID_Plugins_PluginID;
CREATE TRIGGER IF NOT EXISTS fku_ProfilePlugins_PluginID_Plugins_PluginID
                      BEFORE UPDATE
                          ON ProfilePlugins
                    FOR EACH ROW
BEGIN
    SELECT RAISE(ROLLBACK, "Update on table ProfilePlugins violates foreign key constraint FK_ProfilePlugins_0_0") 
     WHERE (
               SELECT PluginID
                 FROM Plugins
                WHERE PluginID = NEW.PluginID
           )
           IS NULL;
END;


-- Trigger: fku_ProfilePlugins_ProfileID_LoadOutProfiles_ProfileID
DROP TRIGGER IF EXISTS fku_ProfilePlugins_ProfileID_LoadOutProfiles_ProfileID;
CREATE TRIGGER IF NOT EXISTS fku_ProfilePlugins_ProfileID_LoadOutProfiles_ProfileID
                      BEFORE UPDATE
                          ON ProfilePlugins
                    FOR EACH ROW
BEGIN
    SELECT RAISE(ROLLBACK, "Update on table ProfilePlugins violates foreign key constraint FK_ProfilePlugins_1_0") 
     WHERE (
               SELECT ProfileID
                 FROM LoadOutProfiles
                WHERE ProfileID = NEW.ProfileID
           )
           IS NULL;
END;


-- Trigger: trgInsteadOfInsert_vwLoadOuts
DROP TRIGGER IF EXISTS trgInsteadOfInsert_vwLoadOuts;
CREATE TRIGGER IF NOT EXISTS trgInsteadOfInsert_vwLoadOuts
                  INSTEAD OF INSERT
                          ON vwLoadOuts
                    FOR EACH ROW
BEGIN-- Insert into LoadOutProfiles table
    INSERT INTO LoadOutProfiles (
                                    ProfileID,
                                    ProfileName,
                                    GroupSetID
                                )
                                VALUES (
                                    NEW.ProfileID,
                                    NEW.ProfileName,
                                    NEW.GroupSetID
                                )
                                ON CONFLICT (
                                    ProfileID
                                )
                                DO UPDATE SET ProfileName = excluded.ProfileName,
                                GroupSetID = excluded.GroupSetID;-- Insert into Plugins table
    INSERT INTO Plugins (
                            PluginID,
                            PluginName,
                            Description,
                            Achievements,
                            DTStamp,
                            Version,
                            State
                        )
                        VALUES (
                            NEW.PluginID,
                            NEW.PluginName,
                            NEW.Description,
                            NEW.Achievements,
                            NEW.TimeStamp,
                            NEW.Version,
                            NEW.State
                        )
                        ON CONFLICT (
                            PluginID
                        )
                        DO UPDATE SET PluginName = excluded.PluginName,
                        Description = excluded.Description,
                        Achievements = excluded.Achievements,
                        DTStamp = excluded.DTStamp,
                        Version = excluded.Version,
                        State = excluded.State;-- Insert into ProfilePlugins table
    INSERT INTO ProfilePlugins (
                                   ProfileID,
                                   PluginID
                               )
                               VALUES (
                                   NEW.ProfileID,
                                   NEW.PluginID
                               )
                               ON CONFLICT (
                                   ProfileID,
                                   PluginID
                               )
                               DO NOTHING;-- Insert into GroupSetPlugins table
    INSERT INTO GroupSetPlugins (
                                    GroupSetID,
                                    GroupID,
                                    PluginID,
                                    Ordinal
                                )
                                VALUES (
                                    NEW.GroupSetID,
                                    NEW.GroupID,
                                    NEW.PluginID,
                                    NEW.GroupOrdinal
                                )
                                ON CONFLICT (
                                    GroupSetID,
                                    GroupID,
                                    PluginID
                                )
                                DO UPDATE SET Ordinal = excluded.Ordinal;-- Insert into ExternalIDs table
    INSERT INTO ExternalIDs (
                                PluginID,
                                BethesdaID,
                                NexusID
                            )
                            VALUES (
                                NEW.PluginID,
                                NEW.BethesdaID,
                                NEW.NexusID
                            )
                            ON CONFLICT (
                                PluginID
                            )
                            DO UPDATE SET BethesdaID = excluded.BethesdaID,
                            NexusID = excluded.NexusID;
END;


-- Trigger: trgInsteadOfInsert_vwModGroups
DROP TRIGGER IF EXISTS trgInsteadOfInsert_vwModGroups;
CREATE TRIGGER IF NOT EXISTS trgInsteadOfInsert_vwModGroups
                  INSTEAD OF INSERT
                          ON vwModGroups
                    FOR EACH ROW
BEGIN-- Insert into ModGroups table
    INSERT INTO ModGroups (
                              GroupID,
                              Ordinal,
                              GroupName,
                              Description,
                              ParentID
                          )
                          VALUES (
                              NEW.GroupID,
                              NEW.Ordinal,
                              NEW.GroupName,
                              NEW.GroupDescription,
                              NEW.ParentID
                          )
                          ON CONFLICT (
                              GroupID
                          )
                          DO UPDATE SET Ordinal = COALESCE(excluded.Ordinal, ModGroups.Ordinal),
                          GroupName = COALESCE(excluded.GroupName, ModGroups.GroupName),
                          Description = COALESCE(excluded.Description, ModGroups.Description),
                          ParentID = COALESCE(excluded.ParentID, ModGroups.ParentID);-- Insert into GroupSetPlugins table
    INSERT INTO GroupSetPlugins (
                                    GroupSetID,
                                    GroupID,
                                    PluginID,
                                    Ordinal
                                )
                                VALUES (
                                    NEW.GroupSetID,
                                    NEW.GroupID,
                                    NEW.PluginID,
                                    NEW.GroupOrdinal
                                )
                                ON CONFLICT (
                                    GroupID,
                                    PluginID
                                )
                                DO UPDATE SET GroupSetID = COALESCE(excluded.GroupSetID, GroupSetPlugins.GroupSetID),
                                Ordinal = COALESCE(excluded.Ordinal, GroupSetPlugins.Ordinal);-- Insert into Plugins table
    INSERT INTO Plugins (
                            PluginID,
                            PluginName,
                            Description,
                            Achievements,
                            DTStamp,
                            Version,
                            State
                        )
                        VALUES (
                            NEW.PluginID,
                            NEW.PluginName,
                            NEW.PluginDescription,
                            NEW.Achievements,
                            NEW.TimeStamp,
                            NEW.Version,
                            NEW.State
                        )
                        ON CONFLICT (
                            PluginID
                        )
                        DO UPDATE SET PluginName = COALESCE(excluded.PluginName, Plugins.PluginName),
                        Description = COALESCE(excluded.Description, Plugins.Description),
                        Achievements = COALESCE(excluded.Achievements, Plugins.Achievements),
                        DTStamp = COALESCE(excluded.DTStamp, Plugins.DTStamp),
                        Version = COALESCE(excluded.Version, Plugins.Version),
                        State = COALESCE(excluded.State, Plugins.State);-- Insert into ExternalIDs table
    INSERT INTO ExternalIDs (
                                PluginID,
                                BethesdaID,
                                NexusID
                            )
                            VALUES (
                                NEW.PluginID,
                                NEW.BethesdaID,
                                NEW.NexusID
                            )
                            ON CONFLICT (
                                PluginID
                            )
                            DO UPDATE SET BethesdaID = COALESCE(excluded.BethesdaID, ExternalIDs.BethesdaID),
                            NexusID = COALESCE(excluded.NexusID, ExternalIDs.NexusID);
END;


-- Trigger: trgInsteadOfInsert_vwPluginFiles
DROP TRIGGER IF EXISTS trgInsteadOfInsert_vwPluginFiles;
CREATE TRIGGER IF NOT EXISTS trgInsteadOfInsert_vwPluginFiles
                  INSTEAD OF INSERT
                          ON vwPluginFiles
                    FOR EACH ROW
BEGIN-- Insert into Plugins table
    INSERT INTO Plugins (
                            PluginID,
                            PluginName
                        )
                        VALUES (
                            NEW.PluginID,
                            NEW.PluginName
                        )
                        ON CONFLICT (
                            PluginID
                        )
                        DO UPDATE SET PluginName = COALESCE(excluded.PluginName, Plugins.PluginName);-- Insert into FileInfo table
    INSERT INTO FileInfo (
                             FileID,
                             PluginID,
                             Filename,
                             RelativePath,
                             DTStamp,
                             HASH,
                             IsArchive
                         )
                         VALUES (
                             NEW.FileID,
                             NEW.PluginID,
                             NEW.Filename,
                             NEW.RelativePath,
                             NEW.DTStamp,
                             NEW.HASH,
                             NEW.IsArchive
                         )
                         ON CONFLICT (
                             FileID
                         )
                         DO UPDATE SET PluginID = COALESCE(excluded.PluginID, FileInfo.PluginID),
                         Filename = COALESCE(excluded.Filename, FileInfo.Filename),
                         RelativePath = COALESCE(excluded.RelativePath, FileInfo.RelativePath),
                         DTStamp = COALESCE(excluded.DTStamp, FileInfo.DTStamp),
                         HASH = COALESCE(excluded.HASH, FileInfo.HASH),
                         IsArchive = COALESCE(excluded.IsArchive, FileInfo.IsArchive);
END;


-- Trigger: trgInsteadOfInsert_vwPlugins
DROP TRIGGER IF EXISTS trgInsteadOfInsert_vwPlugins;
CREATE TRIGGER IF NOT EXISTS trgInsteadOfInsert_vwPlugins
                  INSTEAD OF INSERT
                          ON vwPlugins
                    FOR EACH ROW
BEGIN-- Insert into Plugins table
    INSERT INTO Plugins (
                            PluginID,
                            PluginName,
                            Description,
                            Achievements,
                            DTStamp,
                            Version,
                            BethesdaID,
                            NexusID,
                            GroupID,
                            GroupOrdinal,
                            GroupSetID
                        )
                        VALUES (
                            NEW.PluginID,
                            NEW.PluginName,
                            NEW.Description,
                            NEW.Achievements,
                            NEW.DTStamp,
                            NEW.Version,
                            NEW.BethesdaID,
                            NEW.NexusID,
                            NEW.GroupID,
                            NEW.GroupOrdinal,
                            NEW.GroupSetID
                        )
                        ON CONFLICT (
                            PluginID
                        )
                        DO UPDATE SET PluginName = COALESCE(excluded.PluginName, Plugins.PluginName),
                        Description = COALESCE(excluded.Description, Plugins.Description),
                        Achievements = COALESCE(excluded.Achievements, Plugins.Achievements),
                        DTStamp = COALESCE(excluded.DTStamp, Plugins.DTStamp),
                        Version = COALESCE(excluded.Version, Plugins.Version),
                        BethesdaID = COALESCE(excluded.BethesdaID, Plugins.BethesdaID),
                        NexusID = COALESCE(excluded.NexusID, Plugins.NexusID),
                        GroupID = COALESCE(excluded.GroupID, Plugins.GroupID),
                        GroupOrdinal = COALESCE(excluded.GroupOrdinal, Plugins.GroupOrdinal),
                        GroupSetID = COALESCE(excluded.GroupSetID, Plugins.GroupSetID);
END;


-- Trigger: trgInsteadOfUpdate_vwLoadOuts
DROP TRIGGER IF EXISTS trgInsteadOfUpdate_vwLoadOuts;
CREATE TRIGGER IF NOT EXISTS trgInsteadOfUpdate_vwLoadOuts
                  INSTEAD OF UPDATE
                          ON vwLoadOuts
                    FOR EACH ROW
BEGIN-- Update LoadOutProfiles table
    UPDATE LoadOutProfiles
       SET ProfileName = NEW.ProfileName,
           GroupSetID = NEW.GroupSetID
     WHERE ProfileID = OLD.ProfileID;-- Update Plugins table
    UPDATE Plugins
       SET PluginName = NEW.PluginName,
           Description = NEW.Description,
           Achievements = NEW.Achievements,
           DTStamp = NEW.TimeStamp,
           Version = NEW.Version,
           State = NEW.State
     WHERE PluginID = OLD.PluginID;-- Update ProfilePlugins table
    UPDATE ProfilePlugins
       SET PluginID = NEW.PluginID
     WHERE ProfileID = OLD.ProfileID AND 
           PluginID = OLD.PluginID;-- Update GroupSetPlugins table
    UPDATE GroupSetPlugins
       SET GroupID = NEW.GroupID,
           Ordinal = NEW.GroupOrdinal
     WHERE GroupSetID = OLD.GroupSetID AND 
           PluginID = OLD.PluginID;-- Update ExternalIDs table
    UPDATE ExternalIDs
       SET BethesdaID = NEW.BethesdaID,
           NexusID = NEW.NexusID
     WHERE PluginID = OLD.PluginID;
END;


-- Trigger: trgInsteadOfUpdate_vwModGroups
DROP TRIGGER IF EXISTS trgInsteadOfUpdate_vwModGroups;
CREATE TRIGGER IF NOT EXISTS trgInsteadOfUpdate_vwModGroups
                  INSTEAD OF UPDATE
                          ON vwModGroups
                    FOR EACH ROW
BEGIN-- Update ModGroups table
    UPDATE ModGroups
       SET Ordinal = NEW.Ordinal,
           GroupName = NEW.GroupName,
           Description = NEW.GroupDescription,
           ParentID = NEW.ParentID
     WHERE GroupID = OLD.GroupID;-- Update GroupSetPlugins table
    UPDATE GroupSetPlugins
       SET GroupSetID = NEW.GroupSetID,
           Ordinal = NEW.GroupOrdinal
     WHERE GroupID = OLD.GroupID AND 
           PluginID = OLD.PluginID;-- Update Plugins table
    UPDATE Plugins
       SET PluginName = NEW.PluginName,
           Description = NEW.PluginDescription,
           Achievements = NEW.Achievements,
           DTStamp = NEW.TimeStamp,
           Version = NEW.Version,
           State = NEW.State
     WHERE PluginID = OLD.PluginID;-- Update ExternalIDs table
    UPDATE ExternalIDs
       SET BethesdaID = NEW.BethesdaID,
           NexusID = NEW.NexusID
     WHERE PluginID = OLD.PluginID;
END;


-- View: vwGroupSetGroups
DROP VIEW IF EXISTS vwGroupSetGroups;
CREATE VIEW IF NOT EXISTS vwGroupSetGroups AS
    SELECT gs.GroupSetID,
           gs.GroupSetName,
           mg.GroupID,
           mg.GroupName,
           mg.Description,
           gsg.ParentID,
           gsg.Ordinal
      FROM ModGroups mg
           INNER JOIN
           GroupSetGroups gsg ON mg.GroupID = gsg.GroupID
           INNER JOIN
           GroupSets gs ON gsg.GroupSetID = gs.GroupSetID;


-- View: vwLoadOuts
DROP VIEW IF EXISTS vwLoadOuts;
CREATE VIEW IF NOT EXISTS vwLoadOuts AS
    SELECT l.ProfileID,
           l.ProfileName,
           l.isFavorite,
           p.PluginID,
           p.PluginName,
           p.Description,
           p.Achievements,
           p.DTStamp AS TimeStamp,
           p.Version,
           p.State,
           e.BethesdaID,
           e.NexusID,
           gsp.GroupID,
           gsp.Ordinal AS GroupOrdinal,
           l.GroupSetID,
           CASE WHEN EXISTS (
                   SELECT 1
                     FROM ProfilePlugins pp
                    WHERE pp.ProfileID = l.ProfileID AND 
                          pp.PluginID = p.PluginID
               )
           THEN 1 ELSE 0 END AS IsEnabled
      FROM LoadOutProfiles l
           LEFT JOIN
           ProfilePlugins pp ON l.ProfileID = pp.ProfileID
           LEFT JOIN
           Plugins p ON pp.PluginID = p.PluginID
           LEFT JOIN
           GroupSetPlugins gsp ON p.PluginID = gsp.PluginID AND 
                                  l.GroupSetID = gsp.GroupSetID
           LEFT JOIN
           ModGroups g ON gsp.GroupID = g.GroupID
           LEFT JOIN
           ExternalIDs e ON p.PluginID = e.PluginID
     ORDER BY l.ProfileID,
              gsp.GroupID,
              gsp.Ordinal;


-- View: vwModGroups
DROP VIEW IF EXISTS vwModGroups;
CREATE VIEW IF NOT EXISTS vwModGroups AS
    SELECT g.GroupID,
           gsg.Ordinal,
           g.GroupName,
           g.Description AS GroupDescription,
           gsg.ParentID,
           gsg.GroupSetID,
           p.PluginID,
           p.PluginName,
           p.Description AS PluginDescription,
           p.Achievements,
           p.DTStamp AS TimeStamp,
           p.Version,
           p.State,
           e.BethesdaID,
           e.NexusID,
           gsp.Ordinal AS GroupOrdinal
      FROM ModGroups g
           LEFT JOIN
           GroupSetGroups gsg ON g.GroupID = gsg.GroupID
           LEFT JOIN
           GroupSetPlugins gsp ON gsg.GroupID = gsp.GroupID AND 
                                  gsg.GroupSetID = gsp.GroupSetID
           LEFT JOIN
           Plugins p ON gsp.PluginID = p.PluginID
           LEFT JOIN
           ExternalIDs e ON p.PluginID = e.PluginID
     ORDER BY gsg.GroupSetID,-- Group by GroupSetID
              gsg.ParentID,-- Sort by ParentID
              gsg.Ordinal,-- Sort by Ordinal within ParentID
              gsp.Ordinal;


-- View: vwPluginFiles
DROP VIEW IF EXISTS vwPluginFiles;
CREATE VIEW IF NOT EXISTS vwPluginFiles AS
    SELECT fi.FileID,
           p.PluginID,
           p.PluginName,
           fi.Filename,
           fi.RelativePath,
           fi.DTStamp,
           fi.HASH,
           fi.Flags,
           fi.AbsolutePath
      FROM Plugins p
           JOIN
           FileInfo fi ON p.PluginID = fi.PluginID;


-- View: vwPluginGrpUnion
DROP VIEW IF EXISTS vwPluginGrpUnion;
CREATE VIEW IF NOT EXISTS vwPluginGrpUnion AS
    SELECT/* Plugin Details */ p.PluginID,
           p.PluginName,
           p.Description AS PluginDescription,
           p.Achievements,
           p.DTStamp,
           p.Version,
           p.State,
           gsp.Ordinal AS GroupOrdinal,-- Group Details
           g.GroupID,
           g.GroupName,
           g.Description AS GroupDescription,
           gsg.ParentID,
           gsg.Ordinal AS Ordinal,-- Corrected: gsg.Ordinal represents the order of groups within the groupset
           /* LoadOutProfile Details */l.ProfileID AS LoadOutID,
           l.ProfileName AS LoadOutName,
           CASE WHEN pp.PluginID IS NOT NULL THEN 1 ELSE 0 END AS IsEnabled,-- GroupSet Details
           gsg.GroupSetID,
           gs.GroupSetName,-- External Identifiers
           e.BethesdaID,
           e.NexusID-- Plugin Ordinal Details
      /* Corrected: gsp.Ordinal represents the order of plugins within the group */FROM/* Groupset and Groups are the base tables for the view to ensure all groups and groupsets are included */ GroupSetGroups gsg-- Join ModGroups for Group Information
           LEFT JOIN
           ModGroups g ON gsg.GroupID = g.GroupID-- Join Plugins via GroupSetPlugins (Show all plugins in the group or unassigned)
           LEFT JOIN
           GroupSetPlugins gsp ON gsg.GroupID = gsp.GroupID AND 
                                  gsg.GroupSetID = gsp.GroupSetID
           LEFT JOIN
           Plugins p ON gsp.PluginID = p.PluginID-- ExternalIDs for Bethesda and Nexus mappings
           LEFT JOIN
           ExternalIDs e ON p.PluginID = e.PluginID-- LoadOutProfiles to identify LoadOuts and their mappings
           LEFT JOIN
           LoadOutProfiles l ON l.GroupSetID = gsg.GroupSetID-- ProfilePlugins links LoadOutProfiles with Plugins (For enabling state)
           LEFT JOIN
           ProfilePlugins pp ON pp.ProfileID = l.ProfileID AND 
                                pp.PluginID = p.PluginID-- GroupSet Information
           LEFT JOIN
           GroupSets gs ON gsg.GroupSetID = gs.GroupSetID
     WHERE/* Ensure that entries are associated with either a GroupSet or a LoadOut */ gsg.GroupSetID IS NOT NULL OR 
           l.ProfileID IS NOT NULL
     ORDER BY gsg.GroupSetID,-- Group by GroupSetID
              l.ProfileID,-- Sort by LoadOuts within the GroupSet
              gsg.ParentID,-- Sort by ParentID
              gsg.Ordinal,-- Sort by groups within the group set (group order)
              gsp.Ordinal;


-- View: vwPlugins
DROP VIEW IF EXISTS vwPlugins;
CREATE VIEW IF NOT EXISTS vwPlugins AS-- Script Date: 9/21/2024 1:49 AM  - ErikEJ.SqlCeScripting version 3.5.2.95
    SELECT p.PluginID,
           p.PluginName,
           p.Description,
           p.Achievements,
           p.DTStamp,
           p.Version,
           p.State,
           gsp.GroupSetID,
           gsp.GroupID,
           gsp.Ordinal AS GroupOrdinal,
           g.GroupName,
           e.BethesdaID,
           e.NexusID
      FROM Plugins p
           LEFT JOIN
           GroupSetPlugins gsp ON p.PluginID = gsp.PluginID
           LEFT JOIN
           ModGroups g ON gsp.GroupID = g.GroupID
           LEFT JOIN
           ExternalIDs e ON p.PluginID = e.PluginID;


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
