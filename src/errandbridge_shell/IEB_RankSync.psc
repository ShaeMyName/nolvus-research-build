Scriptname IEB_RankSync Hidden
{Errand Bridge: one-way vanilla relationship-rank sync (spec §11.14.1). LIST A: this script must exist from
 Lucienne's first load, because the patched Relationships SyncBondRank calls Apply on every tier write.
 SHELL SKELETON: empty body; the logic lands in step 3.}

Function Apply(Actor akActor) Global
EndFunction
