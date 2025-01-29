<?php

namespace App\Model;

use Nette;

final class GameFacade
{
	public function __construct(
		private Nette\Database\Explorer $database,
	) {}

	public function getGameById(int $gameId)
	{
		return $this->database
			->table('game')
			->get($gameId);
	}

	public function getAllgame()
	{
		return $this->database
			->table('game');
	}

	public function insertGame($data ){
		return $this->database
			->table('game')
			->insert((array)$data);
	}

	public function editGame(int $gameId, $data)
	{
		$this->database
			->table('game')
			->where('id =', $gameId)
			->update($data);
		return $gameId;
	}

	public function delete(int $id) {
		return $this->getgameById($id)->delete();
	  }
}
