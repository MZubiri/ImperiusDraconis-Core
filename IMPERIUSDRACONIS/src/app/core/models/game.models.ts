export interface GameLinkCode {
  code: string;
  expiresAt: string;
  expiresInSeconds: number;
}

export interface GameAdminDragon {
  id: number;
  name: string;
  speciesCode: string;
  rarity: string;
  level: number;
  stage: string;
  life: number;
  happiness: number;
  hunger: number;
  status: string;
  selected: boolean;
}

export interface GameAdminLedgerEntry {
  id: number;
  amount: number;
  balanceAfter: number;
  reason: string;
  referenceType: string;
  referenceId?: string;
  createdAt: string;
}

export interface GameAdminPlayer {
  idAlumno: number;
  robloxUserId?: number;
  displayName: string;
  dracoins: number;
  eggs: Array<{ id: number; eggDefinitionCode?: string; rarity: string; status: string }>;
  dragons: GameAdminDragon[];
  ledger: GameAdminLedgerEntry[];
}
