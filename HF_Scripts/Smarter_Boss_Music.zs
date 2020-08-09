ffc script BossMusicBeatableOnly
{
	void run(int boss_midi, int enhanced_id)
	{
		Waitframes(4);
		
		int beatables;
		npc enemy;
		int boss1[] = "Anger of the Guardians (from LOZ-ALTTP).spc";
		int boss2[] = "Battle 1 (Crusader of Centy).vgm";
		int boss3[] = "Battle 2 (Crusader of Centy).vgm";
		int boss4[] = "Battle 3 (Crusader of Centy).vgm";
		int boss5[] = "Darkness Returns (KDL2, KPRBB).ogg";
		int boss6[] = "Death Spiral (YS V).spc";
		int boss7[] = "Ganondorf Battle (LOZ-OOT).ogg";
		int boss8[] = "Masters of Land, Sea, and Sky (EVO Search for Eden).spc";
		int boss9[] = "Middle Boss Battle (LOZ-OOT).ogg";
		int boss10[] = "Soldiers of Kakariko Village (LOZ-ALTTP).spc";
		int boss11[] = "The Prince of Darkness (LOZ-ALTTP).spc";
		int boss12[] = "The_Protecters (Ys II).ogg";
		
		int bossm[] = {0, boss1, boss2, boss3, boss4, boss5, boss6, boss7, boss8, boss9, boss10, boss11, boss12};
		
		for (int i = 1; i <= Screen->NumNPCs(); i++)
		{
			enemy = Screen->LoadNPC(i);
			if ((enemy->MiscFlags & 0x08) == 0)
			{
				beatables++;
			}
		}
		if (boss_midi == 36) enhanced_id = 12;
		if (beatables > 0)
		{
			if (!Game->PlayEnhancedMusic(bossm[enhanced_id], 1) || enhanced_id == 0) Game->PlayMIDI(boss_midi);
			while (beatables > 0)
			{
				beatables = 0;
				for (int i = 1; i <= Screen->NumNPCs(); i++)
				{
					enemy = Screen->LoadNPC(i);
					if ((enemy->MiscFlags & 0x08) == 0)
					{
						beatables++;
					}
				}
				Waitframe();
			}
			int buf[256];
			Game->GetDMapMusicFilename(Game->GetCurDMap(), buf);
			if (!Game->PlayEnhancedMusic(buf, 1)) Game->PlayMIDI(Game->DMapMIDI[Game->GetCurDMap()]);
			Quit();
		}
		else
		{
			Quit();
		}
	}
}